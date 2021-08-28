//
//  TYOutboundGoodsModel.h
//  美界联盟
//
//  Created by LY on 2017/11/10.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYOutboundGoodsModel : NSObject

/** 条码类型 */
@property (nonatomic, strong) NSString *ea;
/** 条码 */
@property (nonatomic, strong) NSString *eb;
/** 产品名称 */
@property (nonatomic, strong) NSString *ec;
/** 出库数量 */
@property (nonatomic, assign) NSInteger ed;
/** 入库数量 */
@property (nonatomic, assign) NSInteger ee;
/** 产品单价 */
@property (nonatomic, assign) double eg;


@end
