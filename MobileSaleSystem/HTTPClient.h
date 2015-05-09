//
//  HTTPClient.h
//  PalmMedicine
//
//  Created by wildyao on 15/2/2.
//  Copyright (c) 2015年 Wild Yaoyao. All rights reserved.
//

#import "AFHTTPClient.h"

//#define Base_Url @"http://192.168.1.113:8080/crm/"

#define Base_Url @"http://112.124.43.74/crm/"

@interface HTTPClient : AFHTTPClient

+ (HTTPClient *)sharedClient;

@end
