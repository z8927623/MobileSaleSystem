//
//  ActivityDetailViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/27.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "YYDatePicker.h"

@interface ActivityDetailViewController () <DatePickerDelegate>

//@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) YYDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UILabel *dateLbl;

@end

@implementation ActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnSave:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.title = @"修改计划";
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 180)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:self.textView];
    
    self.textView.text = self.model.detail;
    
    
    self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(_textView.left, _textView.bottom+20, 300, 30)];
    self.dateLbl.text = self.model.time;
    [self.view addSubview:self.dateLbl];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.dateLbl.frame;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(presentDatePicker) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
    
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

//    NSString *dateString = [date substringFromIndex:5];
//    [self.dateFormatter setDateFormat:@"HH:mm"];
//    NSString *timeString = [self.dateFormatter stringFromDate:[NSDate date]];
//    self.dateLbl.text = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
//    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
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
    
    [HTTPManager editActivityWithUserId:nil activityId:self.model.ID activityTime:self.dateLbl.text content:self.textView.text completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Noti4 object:nil];
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];
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
