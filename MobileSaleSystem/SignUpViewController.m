//
//  SignUpViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/27.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismiss
{
    [self.view endEditing:YES];
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
    
    [HTTPManager registerUser:self.field1.text pwd:self.field2.text completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"success: %@", responseObject);
        [SVProgressHUD showHUDWithImage:nil status:@"注册成功" duration:2.0];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"注册失败" duration:2.0];
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
                [SVProgressHUD showHUDWithImage:nil status:@"用户已存在" duration:2.0];
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


@end
