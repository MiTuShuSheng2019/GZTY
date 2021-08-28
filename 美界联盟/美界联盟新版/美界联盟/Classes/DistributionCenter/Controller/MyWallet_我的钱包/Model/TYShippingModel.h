//
//  TYShippingModel.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYShippingModel : NSObject

/** 流水号 */
@property (nonatomic, strong) NSString *da;
/** 金额 备注后台已经处理好无需用double接收了 */
@property (nonatomic, strong) NSString *db;
/** 下级经销商名称 */
@property (nonatomic, strong) NSString *dc;

@end
