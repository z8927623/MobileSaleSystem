//
//  LoginViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/27.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    [HTTPManager login:self.field1.text pwd:self.field2.text completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success: %@", responseObject);
        [SVProgressHUD showHUDWithImage:nil status:@"登录成功" duration:2.0];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"登录失败" duration:2.0];
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


- (IBAction)onBtnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
