//
//  YYDatePicker.h
//  PalmMedicine
//
//  Created by wildyao on 15/1/4.
//  Copyright (c) 2015年 Wild Yaoyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate <NSObject>

- (void)didFinishedSelectDate:(NSString *)date;

@end

@interface YYDatePicker : UIDatePicker

- (id)initWithFrame:(CGRect)frame shadowContainerView:(UIView *)containerView;
- (void)show;
@property (nonatomic, weak) id<DatePickerDelegate> delegate;

@end
