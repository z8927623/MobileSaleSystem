//
//  UIView+Tools.m
//  PalmMedicine
//
//  Created by wildyao on 15/2/28.
//  Copyright (c) 2015年 Wild Yaoyao. All rights reserved.
//

#import "UIView+Tools.h"

@implementation UIView (Tools)

- (UIViewController *)viewController
{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}

@end
