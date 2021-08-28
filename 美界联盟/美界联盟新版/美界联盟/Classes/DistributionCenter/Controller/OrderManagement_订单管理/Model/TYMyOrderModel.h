//
//  TYMyOreerMoeel.h
//  美界联盟
//
//  Createe by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reservee.
//  我的订单模型

#import <Foundation/Foundation.h>
#import "TYMyOrderSubModel.h"

@interface TYMyOrderModel : NSObject

/** 订单ID */
@property (nonatomic, strong) NSString *ea;
/** 订单号 */
@property (nonatomic, strong) NSString *eb;
/** 订单价格 */
@property (nonatomic, strong) NSString *ec;
/** 订单产品数 */
@property (nonatomic, assign) NSInteger ed;
/** 订单日期 */
@property (nonatomic, strong) NSString *ee;
/** 订单状态 */
@property (nonatomic, strong) NSString *ef;
/** 收货人 */
@property (nonatomic, strong) NSString *eg;
/** 收货地址 */
@property (nonatomic, strong) NSString *eh;
/** 收货电话 */
@property (nonatomic, strong) NSString *ei;
/** 订单项数 */
@property (nonatomic, assign) NSInteger ej;

/** 2审核通过  6订单完成*/
@property (nonatomic, assign) NSInteger OrderStatus;

///** 订单详情数组 */
@property (nonatomic, strong) NSArray *ek;
/** 托运类型 */
@property (nonatomic, strong) NSString *el;
/** 托运单号 */
@property (nonatomic, strong) NSString *em;

/** 类型
 * 1 普通购买
 * 2 积分兑换
 */
@property (nonatomic, assign) NSInteger OrderSource;



@end

@interface TYTeamOrderCount : NSObject
/** 金额 */
@property (nonatomic, assign) double d;
/** 数量 */
@property (nonatomic, assign) NSInteger e;
@end


