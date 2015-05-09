//
//  NewActivityViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/27.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "NewActivityViewController.h"
#import "YYDatePicker.h"

@interface NewActivityViewController () <DatePickerDelegate>
@property (nonatomic, strong) YYDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UILabel *dateLbl;
@end

@implementation NewActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnCancel:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnSave:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.navigationItem.title = @"添加新计划";
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 180)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:self.textView];
    
    
    self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(_textView.left, _textView.bottom+20, 300, 30)];
    self.dateLbl.text = @"选择时间";
    [self.view addSubview:self.dateLbl];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.dateLbl.frame;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(presentDatePicker) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
}

- (void)onBtnCancel:(id)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentDatePicker
{
    [self.view endEditing:YES];
    if (!self.datePicker) {
        self.datePicker = [[YYDatePicker alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, DatePickerDefaultHeight) shadowContainerView:self.navigationController.view];
        self.datePicker.delegate = self;
        self.datePicker.minimumDate = [NSDate date];
        [self.view addSubview:self.datePicker];
    }
    
    [self.datePicker show];
}

#pragma mark - DatePickerDelegate

- (void)didFinishedSelectDate:(NSString *)date
{
    if (!date) {
        return;
    }
    
    self.dateLbl.text = date;
    
    NSLog(@"date: %@", date);
}


- (void)dismiss
{
    [self.view endEditing:YES];

}

- (void)onBtnSave:(id)sender
{
    [self.view endEditing:YES];
    
    [SVProgressHUD showProgress];
    
    [HTTPManager addActivityWithUserId:nil date:self.dateLbl.text content:self.textView.text completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD showHUDWithImage:nil status:@"成功" duration:TimeInterval];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Noti4 object:nil];
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];

}

@end
