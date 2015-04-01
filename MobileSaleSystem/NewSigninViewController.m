//
//  NewSigninViewController.m
//  MobileSaleSystem
//
//  Created by wildyao on 15/3/23.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import "NewSigninViewController.h"
#import "CKCalendarView.h"

@interface NewSigninViewController () <CKCalendarDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation NewSigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnCancel:)];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"签到管理";


    self.lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 30)];
    self.lbl.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.lbl];
    
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, _lbl.frame.origin.y+_lbl.frame.size.height+10, 0, 0)];
    self.addressLbl.text = @"签到地点：";
    self.addressLbl.font = [UIFont systemFontOfSize:15];
    [self.addressLbl sizeToFit];
    [self.view addSubview:self.addressLbl];
    
    self.field = [[UITextField alloc] initWithFrame:CGRectMake(_addressLbl.right, _addressLbl.top-5, self.view.width-10-_addressLbl.right, 30)];
    self.field.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.field];
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    calendar.delegate = self;
    calendar.frame = CGRectMake(10, self.field.bottom+10, self.view.frame.size.width-20, 470);
    [self.view addSubview:calendar];
    
    NSString *dateString = [self.dateFormatter stringFromDate:[NSDate date]];
    self.lbl.text = [NSString stringWithFormat:@"签到时间：%@", dateString];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismiss
{
    [self.view endEditing:YES];
}

- (void)save
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onBtnCancel:(id)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - CKCalendarDelegate
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    
    self.lbl.text = [NSString stringWithFormat:@"签到时间：%@", dateString];
    
    NSLog(@"date: %@", date);
    
    
}

@end
