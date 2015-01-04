//
//  AppDelegate.h
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/17.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *_locationmanager;
}


@property (strong, nonatomic) UIWindow *window;


@end

