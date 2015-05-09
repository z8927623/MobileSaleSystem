//
//  LoginViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/27.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    int _type;
}

@end

@implementation LoginViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
    
    _type = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.field1 becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismiss
{
    [self.view endEditing:YES];
}

- (IBAction)onBtnLogin:(id)sender {
    
    if (self.field1.text.length == 0) {
        [SVProgressHUD showHUDWithImage:nil status:@"请输入帐号" duration:2];
        return;
    }
    
    if (self.field2.text.length == 0) {
        [SVProgressHUD showHUDWithImage:nil status:@"请输入密码" duration:2];
        return;
    }
    
    [SVProgressHUD showProgress];
    
    [HTTPManager login:self.field1.text pwd:self.field2.text type:_type completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success: %@", responseObject);
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD showHUDWithImage:nil status:@"登录成功" duration:TimeInterval];
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            [dic setObject:self.field1.text forKey:RegisteredUserKey];
//            [dic setObject:self.field2.text forKey:RegisteredPwdKey];
            
            NSNumber *userId = jsonObject[@"userId"];
            
            if (_type == 0) {
                [[NSUserDefaults standardUserDefaults] setObject:userId forKey:UserIdKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:userId forKey:UserIdKey];
                [[NSUserDefaults standardUserDefaults] setObject:@(1000000) forKey:ManagerIdKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
   
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiLogin object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiLoginLayout object:@(_type)];
            
        } else {
            [SVProgressHUD showHUDWithImage:nil status:jsonObject[@"msg"] duration:TimeInterval];
        }
    
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"登录失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];
    
//    [self performSelector:@selector(loginSuccess) withObject:nil afterDelay:1.0];
}

- (IBAction)onBtnRegister:(id)sender {
    SignUpViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signupvc"];
    [self.navigationController pushViewController:signupVC animated:YES];
}

- (void)loginSuccess
{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:UsersArrKey];
    BOOL user = NO;
    BOOL pwd = NO;
    for (NSDictionary *dic in arr) {
        if ([[dic objectForKey:RegisteredUserKey] isEqualToString:self.field1.text]) {
            user = YES;
            if ([[dic objectForKey:RegisteredPwdKey] isEqualToString:self.field2.text]) {
                pwd = YES;
            } else {
                pwd = NO;
            }
        }
    }
    
    if (!user) {
        [SVProgressHUD showHUDWithImage:nil status:@"用户不存在" duration:1.0];
        return;
    }
    
    if (user && !pwd) {
        [SVProgressHUD showHUDWithImage:nil status:@"密码错误" duration:1.0];
        return;
    }
    
    
    NSArray *clientArr = @[
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" }
                           ];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.field1.text forKey:UserKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.field2.text forKey:PwdKey];
    [[NSUserDefaults standardUserDefaults] setObject:clientArr forKey:ClientListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD dismiss];
}


- (IBAction)onBtnSale:(id)sender {
    [self.saleBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self.managerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _type = 0;
}

- (IBAction)onBtnManager:(id)sender {
    [self.managerBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self.saleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _type = 1;
}

- (IBAction)onBtnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
