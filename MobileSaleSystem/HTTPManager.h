//
//  HTTPManager.h
//  MobileSaleSystem
//
//  Created by wildyao on 15/3/25.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPClient.h"

#define Reg_Url @"/market/admin/Admin!reg"
#define Login_Url  @"/market/admin/Admin!login"

#define ClientList_Url @"/market/admin/User!getUsers"

#define MyInfo_Url @"/market/admin/Admin!getAdmin"
#define EditMyInfo_Url @"/market/admin/Admin!editAdmins"

@interface HTTPManager : NSObject

+ (void)registerUser:(NSString *)name pwd:(NSString *)pwd completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)login:(NSString *)name pwd:(NSString *)pwd completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

/**
 * 获取我的资料
 */
+ (void)getMyInfoWithCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

/**
 * 编辑我的资料
 */
+ (void)editMyInfoWithId:(NSString *)id userid:(NSString *)userid age:(NSString *)age phone:(NSString *)phone sex:(NSString *)sex address:(NSString *)address completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;


+ (void)getClientListWithCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)editClientInfoWithId:(NSString *)id userid:(NSString *)userid age:(NSString *)age phone:(NSString *)phone sex:(NSString *)sex address:(NSString *)address completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)addClientInfoWithUserId:(NSString *)userid age:(NSString *)age phone:(NSString *)phone sex:(NSString *)sex address:(NSString *)address userpwd:(NSString *)userpwd completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

@end
