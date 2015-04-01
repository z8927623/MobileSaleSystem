//
//  NSString+Tools.m
//  PalmMedicine
//
//  Created by wildyao on 15/2/11.
//  Copyright (c) 2015年 Wild Yaoyao. All rights reserved.
//

#import "NSString+Tools.h"
#import "pinyin.h"
#import "ChineseToPinyin.h"

@implementation NSString (Tools)

- (BOOL)safeString
{
    if (!self || self.length == 0 || [self isEqual:[NSNull null]] || [self isEqualToString:@"(null)"]) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)replaceString:(NSString *)replaceString
{
    if (!self || self.length == 0 || [self isEqual:[NSNull null]] || [self isEqualToString:@"(null)"]) {
        return replaceString;
    } else {
        return self;
    }
}

- (NSString *)additionalString:(NSString *)additionalString
{
    if (!self || self.length == 0 || [self isEqual:[NSNull null]] || [self isEqualToString:@"(null)"]) {
        return additionalString;
    } else {
        return [NSString stringWithFormat:@"%@%@", additionalString, self];
    }
}

- (BOOL)isAllSpaceString
{
    return ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0);
}

- (NSString *)removeAllWhiteSpace
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)removeUnknownString
{
   return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
}

- (NSString *)toChinesePinyin
{
    // 效率低
//    NSMutableString *pinyin = [self mutableCopy];
//    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
//    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    
    NSString *pinyin = [ChineseToPinyin pinyinFromChiniseString:self];
    return [pinyin removeAllWhiteSpace];
}

- (NSString *)toChineseJianpin
{
    NSString *jianPinString = [NSString string];
    
    for (int j = 0; j < self.length; j++){  // 单个汉字
        // 单个汉字首字母
        NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([self characterAtIndex:j])] lowercaseString];
        // 词语每个汉字首字母集合
        jianPinString = [jianPinString stringByAppendingString:singlePinyinLetter];
    }
    return [jianPinString removeAllWhiteSpace];
}

- (BOOL)isPureDouble
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    double val;
    return [scan scanDouble:&val] && [scan isAtEnd];
}

- (BOOL)isPureInt
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
