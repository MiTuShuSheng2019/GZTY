//
//  TYValidate.m
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYValidate.h"

@implementation TYValidate

#pragma mark -  判断字符串是否为空,为空的话返回 “” （一般用于保存字典时）
+(NSString *)IsNotNull:(id)string
{
    NSString * str = (NSString*)string;
    if ([self isBlankString:str]){
        string = @"";
    }
    return string;
    
}

//..判断字符串是否为空字符的方法
+(BOOL) isBlankString:(id)string {
    NSString * str = (NSString*)string;
    if ([str isEqual:[NSNull null]]) {
        return YES;
    }
    if ([str isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([str isEqualToString:@"null"]) {
        return YES;
    }
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
