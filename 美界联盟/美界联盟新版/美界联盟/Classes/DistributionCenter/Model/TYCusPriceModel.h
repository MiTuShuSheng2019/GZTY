//
//  TYCusPriceModel.h
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYCusPriceModel : NSObject

/** 发货总金额 */
@property (nonatomic, assign) double d;
/** 零售总金额 */
@property (nonatomic, assign) double e;
/** 代发货总金额 */
@property (nonatomic, assign) double f;
/** 已用充值金额 */
@property (nonatomic, assign) double g;
/** 剩余充值金额 */
@property (nonatomic, assign) double h;
/** 下单总金额 */
@property (nonatomic, assign) double i;
/** 已用下单总金额 */
@property (nonatomic, assign) double j;
/** 剩余下单总金额 */
@property (nonatomic, assign) double k;
/** 总充值金额 */
@property (nonatomic, assign) double l;
/** 订货总额 */
@property (nonatomic, assign) double n;
/** 销售总额 */
@property (nonatomic, assign) double m;

@end
