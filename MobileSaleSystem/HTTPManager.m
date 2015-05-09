//
//  HTTPManager.m
//  MobileSaleSystem
//
//  Created by wildyao on 15/3/25.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager

// 注册登录
+ (void)registerUser:(NSString *)name pwd:(NSString *)pwd type:(int)type completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:pwd forKey:@"pwd"];
    [parameters setObject:@(type) forKey:@"type"];
    
    [[HTTPClient sharedClient] postPath:Reg_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)login:(NSString *)name pwd:(NSString *)pwd type:(int)type completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    [parameters setObject:name forKey:@"name"];
    [parameters setObject:pwd forKey:@"pwd"];
    [parameters setObject:@(type) forKey:@"type"];
    
    [[HTTPClient sharedClient] postPath:Login_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

/**
 * 获取我的资料
 */
+ (void)getUserInfoWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [[HTTPClient sharedClient] getPath:GetUserInfo_Url
                            parameters:parameters
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   completionBlock(operation, responseObject);
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failureBlock(operation, error);
                               }];

}

// 编辑我的资料
+ (void)editUserInfoWithUserId:(NSNumber *)userId name:(NSString *)name age:(NSString *)age phone:(NSString *)phone sex:(NSString *)sex address:(NSString *)address email:(NSString *)email headPic:(NSString *)headPic completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (!userId) {
        NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
        if (ID) {
            [parameters setObject:ID forKey:@"id"];
        } else {
            return;
        }
    } else {
        [parameters setObject:userId forKey:@"id"];
    }

    
    [parameters setObject:name forKey:@"nickName"];
    [parameters setObject:sex forKey:@"sex"];
    [parameters setObject:address forKey:@"address"];
    [parameters setObject:phone forKey:@"linkPhone"];
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:age forKey:@"age"];
//    [parameters setObject:headPic forKey:@"headPic"];
    
    for (NSString *key in parameters.allKeys) {
        if (![key isEqualToString:@"id"]) {
            if (((NSString *)[parameters objectForKey:key]).length == 0) {
                [parameters removeObjectForKey:key];
            }
        }
    }
    
    [[HTTPClient sharedClient] postPath:UpdateUserInfo_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

// 客户管理
+ (void)getClientListWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [[HTTPClient sharedClient] getPath:ClientList_Url
                            parameters:parameters
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   completionBlock(operation, responseObject);
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failureBlock(operation, error);
                               }];
}

+ (void)addClientInfoWithUserId:(NSNumber *)userId name:(NSString *)name age:(NSString *)age phone:(NSString *)phone sex:(NSString *)sex address:(NSString *)address email:(NSString *)email completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:sex forKey:@"sex"];
    [parameters setObject:address forKey:@"address"];
    [parameters setObject:phone forKey:@"linkPhone"];
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:age forKey:@"age"];
    
    [[HTTPClient sharedClient] postPath:AddClient_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)editClientInfoWithUserId:(NSNumber *)userId clientId:(NSNumber *)clientId name:(NSString *)name age:(NSString *)age phone:(NSString *)phone sex:(NSString *)sex address:(NSString *)address email:(NSString *)email headPic:(NSString *)headPic completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [parameters setObject:clientId forKey:@"id"];
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:sex forKey:@"sex"];
    [parameters setObject:address forKey:@"address"];
    [parameters setObject:phone forKey:@"linkPhone"];
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:age forKey:@"age"];
//    [parameters setObject:headPic forKey:@"headPic"];
    
    for (NSString *key in parameters.allKeys) {
        if (![key isEqualToString:@"userId"] && ![key isEqualToString:@"id"]) {
            if (((NSString *)[parameters objectForKey:key]).length == 0) {
                [parameters removeObjectForKey:key];
            }
        }
    }
    
    [[HTTPClient sharedClient] postPath:UpdateClient_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)deleteClientInfoWithUserId:(NSNumber *)userId clientId:(NSNumber *)clientId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [parameters setObject:clientId forKey:@"customerId"];
    
    [[HTTPClient sharedClient] postPath:DeleteClient_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];

}

// 经费申请
+ (void)getFundsListWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [[HTTPClient sharedClient] getPath:FeeList_Url
                            parameters:parameters
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   completionBlock(operation, responseObject);
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failureBlock(operation, error);
                               }];

}

+ (void)getAllFundsListWithCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    [[HTTPClient sharedClient] getPath:FeeList_Url
                            parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   completionBlock(operation, responseObject);
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failureBlock(operation, error);
                               }];
}

+ (void)addFundsWithUserId:(NSNumber *)userId usage:(NSString *)usage money:(NSString *)money completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [parameters setObject:usage forKey:@"usage"];
    [parameters setObject:money forKey:@"money"];
    
    [[HTTPClient sharedClient] postPath:AddFee_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)editFundsWithId:(NSNumber *)ID status:(NSString *)status completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:ID forKey:@"id"];
    [parameters setObject:status forKey:@"status"];
    
    [[HTTPClient sharedClient] postPath:UpdateFee_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

// 活动计划
+ (void)getActivityListWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [[HTTPClient sharedClient] getPath:ActivityList_Url
                            parameters:parameters
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   completionBlock(operation, responseObject);
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failureBlock(operation, error);
                               }];

}

+ (void)addActivityWithUserId:(NSNumber *)userId date:(NSString *)date content:(NSString *)content completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [parameters setObject:date forKey:@"activityTime"];
    [parameters setObject:content forKey:@"activityContent"];
    
    [[HTTPClient sharedClient] postPath:AddActivity_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)editActivityWithUserId:(NSNumber *)userId activityId:(NSNumber *)activityId activityTime:(NSString *)activityTime content:(NSString *)content completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [parameters setObject:activityId forKey:@"id"];
    [parameters setObject:activityTime forKey:@"activityTime"];
    [parameters setObject:content forKey:@"activityContent"];
  
    for (NSString *key in parameters.allKeys) {
        if (![key isEqualToString:@"userId"] && ![key isEqualToString:@"id"]) {
            if (((NSString *)[parameters objectForKey:key]).length == 0) {
                [parameters removeObjectForKey:key];
            }
        }
    }
    
    [[HTTPClient sharedClient] postPath:UpdateActivity_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)deleteActivityWithUserId:(NSNumber *)userId activityId:(NSNumber *)activityId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [parameters setObject:activityId forKey:@"activityId"];
    
    [[HTTPClient sharedClient] postPath:DeleteActivity_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

// 记录管理
+ (void)getRecordListWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [[HTTPClient sharedClient] getPath:NoteList_Url
                            parameters:parameters
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   completionBlock(operation, responseObject);
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failureBlock(operation, error);
                               }];
}

// 添加记录
+ (void)addRecordWithUserId:(NSNumber *)userId content:(NSString *)content completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    // 记录的内容
    [parameters setObject:content forKey:@"note"];
    
    [[HTTPClient sharedClient] postPath:AddNote_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

// 编辑记录
+ (void)editRecordWithUserId:(NSNumber *)userId noteId:(NSNumber *)noteId content:(NSString *)content completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    // 记录Id
    [parameters setObject:noteId forKey:@"id"];
    // 记录的内容
    [parameters setObject:content forKey:@"note"];
    
    [[HTTPClient sharedClient] postPath:UpdateNote_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

// 删除记录
+ (void)deleteRecordWithUserId:(NSNumber *)userId noteId:(NSNumber *)clientId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    // 记录Id
    [parameters setObject:clientId forKey:@"noteId"];
    
    [[HTTPClient sharedClient] postPath:DeleteNote_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}


// 签到管理
+ (void)getSignInListWithUserId:(NSNumber *)userId completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }

    
    [[HTTPClient sharedClient] getPath:SignList_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)getAllSignInListWithCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    [[HTTPClient sharedClient] getPath:SignList_Url
                            parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   completionBlock(operation, responseObject);
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failureBlock(operation, error);
                               }];

}

+ (void)addSignInWithUserId:(NSNumber *)userId date:(NSString *)date place:(NSString *)place completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSNumber *ID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey];
    if (ID) {
        [parameters setObject:ID forKey:@"userId"];
    } else {
        return;
    }
    
    [parameters setObject:date forKey:@"signTime"];
    [parameters setObject:place forKey:@"signPlace"];
    
    [[HTTPClient sharedClient] postPath:AddSign_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

// 销售员列表
+ (void)getSalerListWithCompletionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    [[HTTPClient sharedClient] getPath:list_Url
                            parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   completionBlock(operation, responseObject);
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   failureBlock(operation, error);
                               }];
}

+ (void)uploadAvatar:(NSString *)imageData ID:(NSNumber *)ID type:(int)type completionBlock:(void (^)(AFHTTPRequestOperation *operation, id responObject))completionBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:ID forKey:@"id"];
    [parameters setObject:imageData forKey:@"imgData"];
    [parameters setObject:@(type) forKey:@"type"];
    
    [[HTTPClient sharedClient] postPath:Avatar_Url
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    completionBlock(operation, responseObject);
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    failureBlock(operation, error);
                                }];
}

+ (void)cancelOperation:(NSString *)method path:(NSString *)path
{
    [[HTTPClient sharedClient] cancelAllHTTPOperationsWithMethod:method path:path];
}

@end
