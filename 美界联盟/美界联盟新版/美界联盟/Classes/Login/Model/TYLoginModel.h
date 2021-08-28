//
//  TYLoginModel.h
//  美界APP
//
//  Created by TY-DENG on 2017/9/12.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLoginModel : NSObject

@property (nonatomic,strong) NSString *d; //回话SessionID
@property (nonatomic,strong) NSString *e; //分销商名称
@property (nonatomic,strong) NSString *f; //分销商等级
@property (nonatomic,strong) NSString *g; //分销商电话
@property (nonatomic,strong) NSString *h; //分销商微信
@property (nonatomic,strong) NSString *i; //分销商头像
@property (nonatomic,assign) double j; //销售总额
@property (nonatomic,assign) double k; //订货总额
@property (nonatomic,assign) double l; //待发货
@property (nonatomic,assign) double n; //预充值余额
@property (nonatomic,assign) double m; //预充值总额
@property (nonatomic,assign) double o; //预充值使用金额
@property (nonatomic,assign) double p; //可下单总额
@property (nonatomic,assign) double q; //可下单余额
@property (nonatomic,assign) double r; //可下单使用金额
@property (nonatomic,strong) NSString *s; //等级ID
@property (nonatomic,assign) NSInteger t; //分销商ID
@property (nonatomic,assign) NSString *u; //支付密码
@property (nonatomic,assign) NSString *v; //分销商微信openID
@property (nonatomic,strong) NSString *w; //分销商二维码
@property (nonatomic,assign) NSInteger x; //是否总部
@property (nonatomic,assign) NSInteger y; //体验店id
@property (nonatomic,strong) NSString *aa; //银行卡号

//保存数据
+ (void)saveAccount:( NSMutableDictionary *)userLoginInformationDic;

//保存用户名
+(void)saveName:(NSString *)name;
//保存电话
+(void)savePhone:(NSString *)phone;
//保存微信
+(void)saveWeixin:(NSString *)weixin;
//保存头像
+(void)savePhoto:(NSString *)photo;
//保存预充值余额
+(void)savePrepaidBalance:(NSString *)balance;
//保存预充值使用金额
+(void)savePrerechargeUseAmount:(NSString *)balance;
//保存支付密码
+(void)savePayPassword:(NSString *)password;
//保存银行卡号
+(void)saveBankCardNumber:(NSString *)card;

//返回回话SessionID
+(NSString *)getSessionID;

//返回分销商名称
+ (NSString *)getUserName;

//返回分销商等级
+ (NSString *)getGrade;

//返回分销商电话
+ (NSString *)getPhone;

//返回分销商微信
+ (NSString *)getWeiXing;

//返回分销商头像
+ (NSString *)getPhoto;

//销售总额
+(double)getAotalSell;

//订货总额
+(double)getAotalOrder;

//待发货
+(double)getSendGoods;

//预充值余额
+(double)getPrepaidBalance;

//预充值总额
+(double)getAotalPreloaded;

//预充值使用金额
+(double)getPrerechargeUseAmount;

//可下单总额
+(double)getAvailableOrder;

//可下单余额
+(double)getAvailableBalance;

//可下单使用金额
+(double)getAmountCanBeUsed;

//返回等级ID
+ (NSInteger)getGradeId;

//返回分销商ID
+ (NSInteger)getPrimaryId;

//支付密码
+ (NSString *)getPayPassword;

//分销商微信openID
+ (NSString *)getWeiXingOpenID;

//分销商二维码
+ (NSString *)getDistributorQrCode;

//是否总部
+ (NSInteger)getWhetherHeadquarters;

//体验店id
+ (NSInteger)getExperienceId;

//返回银行卡号
+ (NSString *)getBankCardNumber;

#pragma mark 保存应用唯一表示
+(NSString *)getAPPID;

//清空登录信息
+ (void)cleanUserLoginAllMessage;

@end
