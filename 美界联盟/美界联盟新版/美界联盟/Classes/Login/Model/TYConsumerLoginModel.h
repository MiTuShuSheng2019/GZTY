//
//  TYConsumerLoginModel.h
//  美界联盟
//
//  Created by LY on 2017/12/22.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYConsumerLoginModel : NSObject

@property (nonatomic,strong) NSString *d; //分销商ID
@property (nonatomic,strong) NSString *e; //回话SessionID
@property (nonatomic,strong) NSString *f; //头像地址
@property (nonatomic,strong) NSString *g;//用户名
@property (nonatomic,strong) NSString *h;//电话号码
//保存数据
+ (void)saveAccount:( NSMutableDictionary *)userLoginInformationDic;

//返回分销商ID
+ (NSString *)getPrimaryId;

//返回回话SessionID
+(NSString *)getSessionID;

//返回分销商头像
+ (NSString *)getPhoto;

//返回用户名
+ (NSString *)getUserName;

//返回电话号码
+ (NSString *)getTelephone;

//保存图片
+(void)savePhoto:(NSString *)photo;

//清空登录信息
+ (void)cleanUserLoginAllMessage;

@end
