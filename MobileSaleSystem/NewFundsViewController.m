//
//  NewFundsViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/28.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "NewFundsViewController.h"

@interface NewFundsViewController () <UITextFieldDelegate>

@end

@implementation NewFundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onBtnCancel:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onBtnSave:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    self.field1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 94, self.view.width-20, 40)];
    self.field1.borderStyle = UITextBorderStyleRoundedRect;
    self.field1.placeholder = @"用途";
    self.field1.returnKeyType = UIReturnKeyNext;
    self.field1.delegate = self;
    [self.view addSubview:self.field1];
    
    self.field2 = [[UITextField alloc] initWithFrame:CGRectMake(10, _field1.bottom+20, self.view.width-20, 40)];
    self.field2.borderStyle = UITextBorderStyleRoundedRect;
    self.field2.keyboardType = UIKeyboardTypeDecimalPad;
    self.field2.placeholder = @"金额";
    [self.view addSubview:self.field2];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
}


- (void)dismiss
{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)onBtnCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onBtnSave:(id)sender
{
    [self.view endEditing:YES];
    
    [SVProgressHUD showProgress];
    
    [HTTPManager addFundsWithUserId:nil usage:self.field1.text money:self.field2.text  completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD showHUDWithImage:nil status:@"成功" duration:TimeInterval];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Noti2 object:nil];
            
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.field2 becomeFirstResponder];
    
    return YES;
}

@end
