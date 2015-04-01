//
//  RecordDetailViewController.m
//  MobileSaleSystem
//
//  Created by wildyao on 15/3/22.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import "RecordDetailViewController.h"

@interface RecordDetailViewController ()

@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"记录详情";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 180)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:self.textView];
    
    self.textView.text = self.text;
}

- (void)complete
{
    [self.navigationController popViewControllerAnimated:YES];
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
