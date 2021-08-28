//
//  TYDevice.m
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDevice.h"

@implementation TYDevice

#pragma mark 获取应用唯一标识
+(NSString *)getAPPID{
    NSString *uuId = [[NSUserDefaults standardUserDefaults] objectForKey:@"fsds876duuId"];
    if (!uuId && uuId.length < 4){
        uuId =[[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuId forKey:@"fsds876duuId"];
    }
    return uuId;
}

//获取版本号
+ (int)systemVersion{
    return [[[[UIDevice currentDevice] systemVersion] substringToIndex:2] floatValue];
}

#pragma mark 当前日期转数字
+(NSInteger )getDateDayNow{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //用[NSDate date]可以获取系统当前时间年份
    return [[dateFormatter stringFromDate:[NSDate date]] integerValue];
}

@end
