//
//  NSString+Tools.h
//  PalmMedicine
//
//  Created by wildyao on 15/2/11.
//  Copyright (c) 2015年 Wild Yaoyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

/**
 * 是否为安全string，不为nil，NSNull或者@""
 */
- (BOOL)safeString;

/**
 * 替换string
 */
- (NSString *)replaceString:(NSString *)replace;

/**
 * 替换或附加string
 */
- (NSString *)additionalString:(NSString *)additionalString;

/**
 * 是否全为空格
 */
- (BOOL)isAllSpaceString;

/**
 * 移除所有空格
 */
- (NSString *)removeAllWhiteSpace;

/**
 * 移除所有非字母
 */
- (NSString *)removeUnknownString;

/**
 * 汉字转拼音
 */
- (NSString *)toChinesePinyin;

/**
 * 汉字转简拼
 */
- (NSString *)toChineseJianpin;

/**
 * 是否全为double
 */
- (BOOL)isPureDouble;

/**
 * 是否全为int
 */
- (BOOL)isPureInt;
@end
