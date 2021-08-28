//
//  TYDiffPriceModel.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDiffPriceModel : NSObject

/** 订单和流水发货汇总 */
@property (nonatomic, strong) NSString *d;
/** 零售汇总 */
@property (nonatomic, strong) NSString *e;
/** 总汇总 */
@property (nonatomic, strong) NSString *f;
/** 分销商ID */
@property (nonatomic, strong) NSString *g;

@end
