//
//  TYConsumerAwaitingBigModel.h
//  美界APP
//
//  Created by LY on 2017/11/2.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TYConsumerAwaitingModel.h"

@interface TYConsumerAwaitingBigModel : NSObject
/** 订单PKID */
@property (nonatomic, strong) NSString *da;
/** 订单OrderNo */
@property (nonatomic, strong) NSString *db;
/** 订单状态 */
@property (nonatomic, assign) NSInteger dc;
/** 总价 */
@property (nonatomic, assign) double dd;
/** 商品详情数组 */
@property (nonatomic, strong) NSArray *de;
/** 快递单号 */
@property (nonatomic, strong) NSString *df;
/** 订单总数 */
@property (nonatomic, assign) NSInteger dh;
/** 联系人 */
@property (nonatomic, strong) NSString *di;
/** 收货地址 */
@property (nonatomic, strong) NSString *dj;
/** 时间 */
@property (nonatomic, strong) NSString *dl;
/** 电话 */
@property (nonatomic, strong) NSString *dk;
/** 快递名称 */
@property (nonatomic, strong) NSString *dm;


@end
