//
//  NewRecordViewController.m
//  MobileSaleSystem
//
//  Created by wildyao on 15/3/31.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import "NewRecordViewController.h"

@interface NewRecordViewController ()

@end

@implementation NewRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新建记录";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnCancel)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 180)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:self.textView];
}

- (void)complete
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onBtnCancel
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
