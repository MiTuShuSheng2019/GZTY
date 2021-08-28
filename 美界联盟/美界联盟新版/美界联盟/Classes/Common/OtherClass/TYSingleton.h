//
//  TYSingleton.h
//  美界APP
//
//  Created by LY on 2017/10/18.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYSingleton : NSObject

/** 创建单例类方法 */
+(instancetype)shareSingleton;

/**
 * 此值用于存储登陆者的状态，注意使用了
 * consumer=1 表示消费登录
 * consumer=2 表示分销商登录
 */
@property (nonatomic, assign) NSInteger consumer;

/** 存放购物车里面的数据 */
@property (nonatomic, strong) NSMutableArray *shopArr;

/** 销售总额 */
@property (nonatomic, assign) double totalSales;
/** 待发货总额 */
@property (nonatomic, assign) double totalAwaiting;
/** 发货总金额 */
@property (nonatomic, assign) double totalDelivery;
/** 零售总金额 */
@property (nonatomic, assign) double totalRetailValue;

/** 线上版本号 */
@property (nonatomic, strong) NSString *version;

@end
