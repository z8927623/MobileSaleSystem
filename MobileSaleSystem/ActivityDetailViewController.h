//
//  ActivityDetailViewController.h
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/27.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "CommonViewController.h"
#import "PlanModel.h"

@interface ActivityDetailViewController : CommonViewController

@property (nonatomic, strong) PlanModel *model;

@property (nonatomic, strong) UITextView *textView;

//@property (nonatomic, strong) NSString *text;


@end
