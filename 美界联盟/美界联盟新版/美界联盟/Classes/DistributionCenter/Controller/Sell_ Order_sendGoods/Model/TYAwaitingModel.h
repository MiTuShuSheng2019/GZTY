//
//  TYAwaitingModel.h
//  美界app
//
//  Created by LY on 2017/10/21.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYAwaitingModel : NSObject

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
/** 商品数组 */
@property (nonatomic, strong) NSArray *ek;
/** 托运类型 */
@property (nonatomic, strong) NSString *el;
/** 托运单号 */
@property (nonatomic, strong) NSString *em;

@end
