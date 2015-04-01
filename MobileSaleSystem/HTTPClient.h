//
//  HTTPClient.h
//  PalmMedicine
//
//  Created by wildyao on 15/2/2.
//  Copyright (c) 2015年 Wild Yaoyao. All rights reserved.
//

#import "AFHTTPClient.h"

@interface HTTPClient : AFHTTPClient

+ (HTTPClient *)sharedClient;

@end
