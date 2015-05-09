//
//  SignUpViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/27.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
{
    int _type;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.field1 becomeFirstResponder];
}


- (void)dismiss
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.field1]) {
        [self.field1 resignFirstResponder];
        [self.field2 becomeFirstResponder];
    } else {
        [self.field2 resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)onBtnRegister:(id)sender {
    
    if (self.field1.text.length == 0) {
        [SVProgressHUD showHUDWithImage:nil status:@"请输入帐号" duration:2];
        return;
    }
    
    if (self.field2.text.length == 0) {
        [SVProgressHUD showHUDWithImage:nil status:@"请输入密码" duration:2];
        return;
    }
    
    [SVProgressHUD showProgress];
    
//    [self performSelector:@selector(registerSuccess) withObject:nil afterDelay:1.0];
    
    [HTTPManager registerUser:self.field1.text pwd:self.field2.text type:_type completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD showHUDWithImage:nil status:@"注册成功" duration:TimeInterval];
            
            NSNumber *userId = jsonObject[@"userId"];
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:UserIdKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"注册失败" duration:TimeInterval];
        }
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"注册失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];
}


- (void)registerSuccess
{
    NSMutableArray *arr = nil;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UsersArrKey]) {
        arr = [NSMutableArray array];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.field1.text forKey:RegisteredUserKey];
        [dic setObject:self.field2.text forKey:RegisteredPwdKey];
        
        [arr addObject:dic];
    } else {
        arr = [[NSUserDefaults standardUserDefaults] objectForKey:UsersArrKey];
        
        for (NSDictionary *dic in arr) {
            if ([[dic objectForKey:RegisteredUserKey] isEqualToString:self.field1.text]) {
                [SVProgressHUD showHUDWithImage:nil status:@"用户已存在" duration:TimeInterval];
                return;
            }
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.field1.text forKey:RegisteredUserKey];
        [dic setObject:self.field2.text forKey:RegisteredPwdKey];
        [arr addObject:dic];
    }
    

    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:UsersArrKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [SVProgressHUD dismiss];
}


//- (void)onBtnCancel:(id)sender
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//


- (IBAction)onBtnSaler:(id)sender {
    [self.salerBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self.managerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _type = 0;

}

- (IBAction)onBtnManager:(id)sender {
    [self.managerBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self.salerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _type = 1;
}
@end
