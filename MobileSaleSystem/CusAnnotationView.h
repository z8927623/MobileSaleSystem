//
//  CusAnnotationView.h
//  MAMapKit_static_demo
//
//  Created by songjian on 13-10-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@protocol DidSelectAnnotationCalloutViewDelegate <NSObject>

- (void)didSelectAnnotationCalloutViewDelegate:(id)obj source:(id)source;

@end

@interface CusAnnotationView : MAAnnotationView

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;

@property (nonatomic, copy) NSString *calloutText;

@property (nonatomic, weak) id <DidSelectAnnotationCalloutViewDelegate> delegate;

@end
