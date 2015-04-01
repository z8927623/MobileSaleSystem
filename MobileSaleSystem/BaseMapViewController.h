//
//  BaseMapViewController.h
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/28.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "CommonViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface BaseMapViewController : CommonViewController <MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

- (void)clearMapView;
- (void)clearSearch;
@end
