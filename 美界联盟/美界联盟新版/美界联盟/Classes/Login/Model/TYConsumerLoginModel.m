//
//  TYConsumerLoginModel.m
//  美界联盟
//
//  Created by LY on 2017/12/22.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYConsumerLoginModel.h"

@implementation TYConsumerLoginModel

+ (void)saveAccount:( NSMutableDictionary *)userLoginInformationDic{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *d = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"d"]];
    NSString *e = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"e"]];
    NSString *f = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"f"]];
    NSString *g = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"g"]];
    NSString *h = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"h"]];
    
    //保存数据
    [userDefaults setObject:d  forKey:@"d" ];
    [userDefaults setObject:e  forKey:@"e" ];
    [userDefaults setObject:f  forKey:@"f" ];
    [userDefaults setObject:g  forKey:@"g" ];
    [userDefaults setObject:h  forKey:@"h" ];
}

//返回分销商ID
+(NSString *)getPrimaryId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *d = [userDefaults objectForKey:@"d"];
    return d;
}

//返回SessionID
+ (NSString *)getSessionID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *e = [userDefaults objectForKey:@"e"];
    return e;
}

//返回分销商头像
+ (NSString *)getPhoto{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *f = [userDefaults objectForKey:@"f"];
    return f;
}

//返回用户名
+ (NSString *)getUserName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *g = [userDefaults objectForKey:@"g"];
    return g;
}

//返回电话号码
+ (NSString *)getTelephone{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *h = [userDefaults objectForKey:@"h"];
    return h;
}

//保存图片
+(void)savePhoto:(NSString *)photo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [userDefaults setObject:photo forKey:@"f" ];
}

//清空登录信息
+ (void)cleanUserLoginAllMessage
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"d"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"e"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"f"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"g"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"h"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
