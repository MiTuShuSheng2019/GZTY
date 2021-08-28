//
//  TYConsumerAwaitingModel.h
//  美界APP
//
//  Created by LY on 2017/11/2.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYConsumerAwaitingModel : NSObject

/** 订单明细orderno */
@property (nonatomic, strong) NSString *dea;
/** 产品ID */
@property (nonatomic, assign) NSInteger deb;
/** 产品数量 */
@property (nonatomic, assign) NSInteger dec;
/** 产品单价 */
@property (nonatomic, assign) double ded;
/** 订单明细PKID */
@property (nonatomic, strong) NSString *dee;
/** 产品主图 */
@property (nonatomic, strong) NSString *def;
/** 产品名称 */
@property (nonatomic, strong) NSString *deg;
/** 单价 */
@property (nonatomic, assign) double deh;



@end
