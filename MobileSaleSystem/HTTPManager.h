//
//  HTTPManager.h
//  MobileSaleSystem
//
//  Created by wildyao on 15/3/25.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPClient.h"

//#define Reg_Url @"/market/admin/Admin!reg"
//#define Login_Url  @"/market/admin/Admin!login"

#define Reg_Url @"user/register"
#define Login_Url  @"user/login"

#define list_Url  @"user/list"

// 个人资料
#define GetUserInfo_Url @"user/detail"
#define UpdateUserInfo_Url @"user/update"

// 客户管理
#define AddClient_Url @"customer/add"
#define ClientList_Url @"customer/list"
#define UpdateClient_Url @"customer/update"
#define DeleteClient_Url @"customer/del"

// 经费申请
#define AddFee_Url @"fee/add"
#define FeeList_Url @"fee/list"
#define UpdateFee_Url @"fee/update"
#define DeleteFee_Url @"fee/del"

// 活动计划
#define AddActivity_Url @"activity/add"
#define ActivityList_Url @"activity/list"
#define UpdateActivity_Url @"activity/update"
#define DeleteActivity_Url @"activity/del"

// 记录管理
#define AddNote_Url @"note/add"
#define NoteList_Url @"note/list"
#define UpdateNote_Url @"note/update"
#define DeleteNote_Url @"note/del"

// 签到
#define AddSign_Url @"sign/add"
#define SignList_Url @"sign/list"

#define Avatar_Url @"file/upload"


@interface HTTPManager : NSObject

// 注册登录
+ (void)registerUser:(NSString *)name pwd:(NSString *)pwd type:(int)type completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)login:(NSString *)name pwd:(NSString *)pwd type:(int)type completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

 // 获取我的资料
+ (void)getUserInfoWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

// 编辑我的资料
+ (void)editUserInfoWithUserId:(NSNumber *)userId name:(NSString *)name age:(NSString *)age phone:(NSString *)phone sex:(NSString *)sex address:(NSString *)address email:(NSString *)email headPic:(NSString *)headPic completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

// 客户管理
+ (void)getClientListWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)addClientInfoWithUserId:(NSNumber *)userId name:(NSString *)name age:(NSString *)age phone:(NSString *)phone sex:(NSString *)sex address:(NSString *)address email:(NSString *)email completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)editClientInfoWithUserId:(NSNumber *)userId clientId:(NSNumber *)clientId name:(NSString *)name age:(NSString *)age phone:(NSString *)phone sex:(NSString *)sex address:(NSString *)address email:(NSString *)email headPic:(NSString *)headPic completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)deleteClientInfoWithUserId:(NSNumber *)userId clientId:(NSNumber *)clientId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

// 经费申请
+ (void)getFundsListWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)getAllFundsListWithCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)addFundsWithUserId:(NSNumber *)userId usage:(NSString *)usage money:(NSString *)money completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)editFundsWithId:(NSNumber *)ID status:(NSString *)status completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

// 活动计划
+ (void)getActivityListWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)addActivityWithUserId:(NSNumber *)userId date:(NSString *)date content:(NSString *)content completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)editActivityWithUserId:(NSNumber *)userId activityId:(NSNumber *)activityId activityTime:(NSString *)activityTime content:(NSString *)content completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)deleteActivityWithUserId:(NSNumber *)userId activityId:(NSNumber *)activityId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

// 记录管理
+ (void)getRecordListWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)addRecordWithUserId:(NSString *)userId content:(NSString *)content completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)editRecordWithUserId:(NSNumber *)userId noteId:(NSNumber *)noteId content:(NSString *)content completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)deleteRecordWithUserId:(NSNumber *)userId noteId:(NSNumber *)clientId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;


// 签到管理
+ (void)getSignInListWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)getAllSignInListWithCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)addSignInWithUserId:(NSNumber *)userId date:(NSString *)date place:(NSString *)place completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

// 销售员列表
+ (void)getSalerListWithCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)uploadAvatar:(NSString *)imageData ID:(NSNumber *)ID type:(int)type completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)cancelOperation:(NSString *)method path:(NSString *)path;

@end
