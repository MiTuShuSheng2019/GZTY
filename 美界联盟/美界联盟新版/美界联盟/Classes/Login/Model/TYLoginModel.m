//
//  TYLoginModel.m
//  美界APP
//
//  Created by TY-DENG on 2017/9/12.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYLoginModel.h"

@implementation TYLoginModel

SYNTHESIZE_SINGLETON_FOR_CLASS(TYLoginModel)

+ (void)saveAccount:( NSMutableDictionary *)userLoginInformationDic{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *d = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"d"]];
    NSString *e = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"e"]];
    NSString *f = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"f"]];
    NSString *g = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"g"]];
    NSString *h = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"h"]];
    NSString *i = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"i"]];
    
    double j = [[userLoginInformationDic objectForKey:@"j"] doubleValue];
    double k = [[userLoginInformationDic objectForKey:@"k"] doubleValue];
    double l = [[userLoginInformationDic objectForKey:@"l"] doubleValue];
    double n = [[userLoginInformationDic objectForKey:@"n"] doubleValue];
    double m = [[userLoginInformationDic objectForKey:@"m"] doubleValue];
    double o = [[userLoginInformationDic objectForKey:@"o"] doubleValue];
    double p = [[userLoginInformationDic objectForKey:@"p"] doubleValue];
    double q = [[userLoginInformationDic objectForKey:@"q"] doubleValue];
    double r = [[userLoginInformationDic objectForKey:@"r"] doubleValue];
    
    NSString *s = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"s"]];
    NSInteger t = [[userLoginInformationDic objectForKey:@"t"] integerValue];
    NSString *u = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"u"]];
    NSString *v = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"v"]];
    NSString *w = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"w"]];
    NSString *aa = [NSString stringWithFormat:@"%@",[userLoginInformationDic objectForKey:@"aa"]];
    NSInteger x = [[userLoginInformationDic objectForKey:@"x"] integerValue];
    NSInteger y = [[userLoginInformationDic objectForKey:@"y"] integerValue];
    
    //保存数据
    [userDefaults setObject:d  forKey:@"d" ];
    [userDefaults setObject:e  forKey:@"e" ];
    [userDefaults setObject:f  forKey:@"f" ];
    [userDefaults setObject:g  forKey:@"g" ];
    [userDefaults setObject:h  forKey:@"h"];
    [userDefaults setObject:i  forKey:@"i" ];
    [userDefaults setObject:@(j) forKey:@"j" ];
    
    [userDefaults setObject:@(k)  forKey:@"k" ];
    [userDefaults setObject:@(l)  forKey:@"l" ];
    [userDefaults setObject:@(n)  forKey:@"n"];
    [userDefaults setObject:@(m)  forKey:@"m" ];
    [userDefaults setObject:@(o)  forKey:@"o" ];
    [userDefaults setObject:@(p)  forKey:@"p" ];
    [userDefaults setObject:@(q)  forKey:@"q" ];
    [userDefaults setObject:@(r)  forKey:@"r"];
    
    [userDefaults setObject:s  forKey:@"s"];
    [userDefaults setObject:@(t)  forKey:@"t"];
    [userDefaults setObject:u  forKey:@"u" ];
    [userDefaults setObject:v  forKey:@"v" ];
    [userDefaults setObject:w  forKey:@"w"];
    [userDefaults setObject:@(x)  forKey:@"x"];
    [userDefaults setObject:@(y)  forKey:@"y"];
    [userDefaults setObject:aa  forKey:@"aa" ];
};

//保存用户名
+(void)saveName:(NSString *)name{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [userDefaults setObject:name forKey:@"e" ];
}

//保存电话
+(void)savePhone:(NSString *)phone{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [userDefaults setObject:phone forKey:@"g" ];
}

//保存微信
+(void)saveWeixin:(NSString *)weixin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [userDefaults setObject:weixin forKey:@"h" ];
}

//保存头像
+(void)savePhoto:(NSString *)photo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [userDefaults setObject:photo forKey:@"i" ];
}

//保存预充值余额
+(void)savePrepaidBalance:(NSString *)balance{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [userDefaults setObject:balance forKey:@"n" ];
}

//保存预充值使用金额
+(void)savePrerechargeUseAmount:(NSString *)balance{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [userDefaults setObject:balance forKey:@"o" ];
}

//保存支付密码
+(void)savePayPassword:(NSString *)password{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [userDefaults setObject:password forKey:@"u" ];
}

//保存银行卡号
+(void)saveBankCardNumber:(NSString *)card{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [userDefaults setObject:card forKey:@"aa" ];
}

//返回回话SessionID
+(NSString *)getSessionID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *d = [userDefaults objectForKey:@"d"];
    return d;
}

//返回分销商名称
+ (NSString *)getUserName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *e = [userDefaults objectForKey:@"e"];
    return e;
}

//返回分销商等级
+ (NSString *)getGrade{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *f = [userDefaults objectForKey:@"f"];
    return f;
}

//返回分销商电话
+ (NSString *)getPhone{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *g = [userDefaults objectForKey:@"g"];
    return g;
}

//返回分销商微信
+ (NSString *)getWeiXing{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *h = [userDefaults objectForKey:@"h"];
    return h;
}

//返回分销商头像
+ (NSString *)getPhoto{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *i = [userDefaults objectForKey:@"i"];
    return i;
}

//销售总额
+(double)getAotalSell{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double j = [[userDefaults objectForKey:@"j"] doubleValue];
    return j;
}

//订货总额
+(double)getAotalOrder{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double k = [[userDefaults objectForKey:@"k"] doubleValue];
    return k;
}

//待发货
+(double)getSendGoods{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double l = [[userDefaults objectForKey:@"l"] doubleValue];
    return l;
}

//预充值余额
+(double)getPrepaidBalance{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double n = [[userDefaults objectForKey:@"n"] doubleValue];
    return n;
}

//预充值总额
+(double)getAotalPreloaded{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double m = [[userDefaults objectForKey:@"m"] doubleValue];
    return m;
}

//预充值使用金额
+(double)getPrerechargeUseAmount{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double o = [[userDefaults objectForKey:@"o"] doubleValue];
    return o;
}

//可下单总额
+(double)getAvailableOrder{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double p = [[userDefaults objectForKey:@"p"] doubleValue];
    return p;
}

//可下单余额
+(double)getAvailableBalance{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double q = [[userDefaults objectForKey:@"q"] doubleValue];
    return q;
}

//可下单使用金额
+(double)getAmountCanBeUsed{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double r = [[userDefaults objectForKey:@"r"] doubleValue];
    return r;
}

//返回等级ID
+ (NSInteger)getGradeId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger s = [[userDefaults objectForKey:@"s"] integerValue];
    return s;
}

//返回分销商ID
+ (NSInteger)getPrimaryId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger t = [[userDefaults objectForKey:@"t"] integerValue];
    return t;
}

//支付密码
+ (NSString *)getPayPassword{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *u = [userDefaults objectForKey:@"u"];
    return u;
}

//分销商微信openID
+ (NSString *)getWeiXingOpenID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *v = [userDefaults objectForKey:@"v"];
    return v;
}

//分销商二维码
+ (NSString *)getDistributorQrCode{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *w = [userDefaults objectForKey:@"w"];
    return w;
}

//是否总部
+ (NSInteger)getWhetherHeadquarters{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger x = [[userDefaults objectForKey:@"x"] integerValue];
    return x;
}

//体验店id
+ (NSInteger)getExperienceId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger y = [[userDefaults objectForKey:@"y"] integerValue];
    return y;
}

//返回银行卡号
+ (NSString *)getBankCardNumber{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *aa = [userDefaults objectForKey:@"aa"];
    return aa;
}

#pragma mark 保存应用唯一表示
+(NSString *) getAPPID{
    NSString *uuId = [[NSUserDefaults standardUserDefaults] objectForKey:@"fsds876duuId"];
    if (!uuId && uuId.length <4){
        uuId =[[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuId forKey:@"fsds876duuId"];
    }
    return uuId;
}


//清空登录信息
+ (void)cleanUserLoginAllMessage
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"d"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"e"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"f"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"g"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"h"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"i"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"j"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"k"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"l"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"n"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"m"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"o"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"p"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"q"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"r"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"s"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"t"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"u"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"v"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"w"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"x"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"y"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"aa"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
