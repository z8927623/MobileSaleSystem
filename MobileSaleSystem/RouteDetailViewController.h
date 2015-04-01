//
//  RouteDetailViewController.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-19.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CommonViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
@interface RouteDetailViewController : CommonViewController

@property (nonatomic, strong) AMapRoute *route;

@property (nonatomic) AMapSearchType searchType;

@end
