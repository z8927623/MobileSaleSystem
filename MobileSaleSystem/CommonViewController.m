//
//  CommonViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/27.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (self.needsBackItem) {
        // 1. 设置leftBarButtonItem，手势返回不可用，可以使用自定义push/pop动画
        
        // 1.1 使用系统UIBarButtonItem
        // 设置图片颜色，默认使用系统的蓝色
//        self.navigationController.navigationBar.tintColor = [UIColor redColor];
//        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
//        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-bar-back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(onBtnBack:)];
//        self.navigationItem.leftBarButtonItem = leftItem;
//        // 可以根据需要设置偏移量
//        //    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        
        
        // 1.2 自定义UIBarButtonItem
        //    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //    backBtn.frame = CGRectMake(0, 0, 40, 40);
        //    [backBtn setImage:[UIImage imageNamed:@"navigation-bar-back-icon"] forState:UIControlStateNormal];
        //    [backBtn addTarget:self action:@selector(onBtnBack:) forControlEvents:UIControlEventTouchUpInside];
        //    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        //    UIBarButtonItem *space_left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //    // 往左偏移10 dots
        //    space_left.width = -10;
        //    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space_left, leftItem, nil];
        //    // imageInsets在自定义UIBarButtonItem时候没用
        ////    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        
        
        // 2. 设置backBarButtonItem，无法调整位置，但手势返回可用
        // 见AppDelegate
    }
}

- (void)onBtnBack:(id)sender
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
