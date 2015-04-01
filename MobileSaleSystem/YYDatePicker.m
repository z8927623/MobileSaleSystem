//
//  YYDatePicker.m
//  PalmMedicine
//
//  Created by wildyao on 15/1/4.
//  Copyright (c) 2015年 Wild Yaoyao. All rights reserved.
//

#import "YYDatePicker.h"

#define Height_Bar 40

@interface YYDatePicker ()

@property (nonatomic, strong) UIButton *shadowView;
@property (nonatomic, strong) UIView *actionBar;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *selectedDateString;

@end

@implementation YYDatePicker


- (id)initWithFrame:(CGRect)frame shadowContainerView:(UIView *)containerView
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.containerView = containerView;
        
        self.backgroundColor = [UIColor whiteColor];
        self.datePickerMode = UIDatePickerModeDate;
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.date = [NSDate date];
        self.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        self.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
        
        self.minimumDate = [_dateFormatter dateFromString:@"1900-01-01"];
        self.maximumDate = [_dateFormatter dateFromString:@"2099-12-31"];
        
        self.shadowView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shadowView.frame = CGRectMake(0, 0, containerView.width, containerView.height);
        self.shadowView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        self.shadowView.alpha = 0.0;
        [self.shadowView addTarget:self action:@selector(onBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:self.shadowView];
        
        self.actionBar = [[UIView alloc] initWithFrame:CGRectMake(0, containerView.height, containerView.width, Height_Bar)];
        self.actionBar.backgroundColor = [UIColor whiteColor];
        [containerView addSubview:self.actionBar];
        
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.confirmBtn.frame = CGRectMake(_actionBar.width-60, 0, 50, Height_Bar);
        self.confirmBtn.centerY = _actionBar.height/2;
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.confirmBtn.titleLabel.font = FONT(19);
        [self.confirmBtn addTarget:self action:@selector(onBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionBar addSubview:self.confirmBtn];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.cancelBtn.frame = CGRectMake(10, 0, 50, Height_Bar);
        self.cancelBtn.centerY = _actionBar.height/2;
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = FONT(19);
        [self.cancelBtn addTarget:self action:@selector(onBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionBar addSubview:self.cancelBtn];
        
        // observe frame's change
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        [self addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)dealloc
{
    // remember to remove, or crash
    [self removeObserver:self forKeyPath:@"frame"];
}

- (void)setDate:(NSDate *)date {
    [super setDate:date];
    
    self.selectedDateString = [_dateFormatter stringFromDate:date];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    self.selectedDateString = [_dateFormatter stringFromDate:[datePicker date]];
}

- (void)onBtnConfirm:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedSelectDate:)]) {
        NSString *date = _selectedDateString;
        [self.delegate didFinishedSelectDate:date];
        [self onBtnDismiss:nil];
    }
}

- (void)onBtnCancel:(id)sender
{
    [self.delegate didFinishedSelectDate:nil];
    [self onBtnDismiss:nil];
}

- (void)show
{
    ((UINavigationController *)self.containerView.viewController).interactivePopGestureRecognizer.enabled = NO;
    [UIView animateWithDuration:0.35 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = self.superview.height-DatePickerDefaultHeight;
        self.frame = rect;
    }];
}

- (void)onBtnDismiss:(id)sender
{
    ((UINavigationController *)self.containerView.viewController).interactivePopGestureRecognizer.enabled = YES;
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = self.frame;
                         rect.origin.y = self.superview.height;
                         self.frame = rect;
                     }
                     completion:^(BOOL finished){
//                         [self removeFromSuperview];
                     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"frame"]) {
        
        // 当frame变化时候同步变化shadowView
        if (self.shadowView.alpha == 0.0) {
            
            [UIView animateWithDuration:0.35 animations:^{
                CGRect rect = self.shadowView.frame;
//                rect.size.height -= self.height;
                rect.size.height = self.containerView.height-self.height-Height_Bar;
                self.shadowView.frame = rect;
                
                rect = self.actionBar.frame;
                rect.origin.y = self.containerView.height-self.height-Height_Bar;
                self.actionBar.frame = rect;
                
                self.shadowView.alpha = 1.0;
            }];

        } else {
            [UIView animateWithDuration:0.35 animations:^{
                
                CGRect rect = self.shadowView.frame;
//                rect.size.height += self.height;
                rect.size.height = self.containerView.height;
                self.shadowView.frame = rect;
                
                rect = self.actionBar.frame;
                rect.origin.y = self.containerView.height;
                self.actionBar.frame = rect;
                
                self.shadowView.alpha = 0.0;
            } completion:^(BOOL finished) {
//                [self.shadowView removeFromSuperview];
            }];
        }
        
    }
}

@end
