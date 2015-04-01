//
//  CusAnnotationView.h
//  MAMapKit_static_demo
//
//  Created by songjian on 13-10-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CusAnnotationView : MAAnnotationView

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;

@property (nonatomic, copy) NSString *calloutText;

@end
