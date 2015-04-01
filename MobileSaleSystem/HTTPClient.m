//
//  HTTPClient.m
//  PalmMedicine
//
//  Created by wildyao on 15/2/2.
//  Copyright (c) 2015年 Wild Yaoyao. All rights reserved.
//

#import "HTTPClient.h"
#import "AFJSONRequestOperation.h"

#define Base_Url @"http://117.149.6.196:8080"

@implementation HTTPClient

+ (HTTPClient *)sharedClient
{
    static HTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:Base_Url]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        
        // AFNetworking默认传回data
        // 自定义头部，返回data
        // 未自定义头部，设置下列之后，返回json
        
//        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        // post参数编码
//        self.parameterEncoding = AFJSONParameterEncoding;
    }
    
    return self;
}

@end
