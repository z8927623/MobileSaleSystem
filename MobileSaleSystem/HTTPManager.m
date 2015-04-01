//
//  HTTPManager.m
//  MobileSaleSystem
//
//  Created by wildyao on 15/3/25.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager

+ (void)registerUser:(NSString *)name pwd:(NSString *)pwd completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:name forKey:@"adminDTO.adminid"];
    [parameters setObject:pwd forKey:@"adminDTO.adminpwd"];
    
    [[HTTPClient sharedClient] postPath:Reg_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)login:(NSString *)name pwd:(NSString *)pwd completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:name forKey:@"adminid"];
    [parameters setObject:pwd forKey:@"adminpwd"];
    
    [[HTTPClient sharedClient] postPath:Login_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)getMyInfoWithCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    [[HTTPClient sharedClient] getPath:MyInfo_Url
                             parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)getClientListWithCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    [[HTTPClient sharedClient] getPath:ClientList_Url
                              parameters:nil
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     completionBlock(operation, responseObject);
                                 }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     failureBlock(operation, error);
                                 }];
    
}

@end
