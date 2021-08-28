//
//  TYOutStorageModel.h
//  美界联盟
//
//  Created by LY on 2017/11/10.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYOutStorageModel : NSObject

/** 出库ID */
@property (nonatomic, strong) NSString *ea;
/** 出库流水号 */
@property (nonatomic, strong) NSString *eb;
/** 入库分销商 */
@property (nonatomic, strong) NSString *ec;
/** 分销商电话 */
@property (nonatomic, strong) NSString *ed;
/** 创建时间 */
@property (nonatomic, strong) NSString *ee;
/** 出库数量 */
@property (nonatomic, assign) NSInteger ef;
/** 产品总价 */
@property (nonatomic, assign) double eg;
/** 收货联系人 */
@property (nonatomic, strong) NSString *eh;
/** 收货地址 */
@property (nonatomic, strong) NSString *ei;
/** 托运单类型 */
@property (nonatomic, strong) NSString *ej;
/** 托运单单号 */
@property (nonatomic, strong) NSString *ek;
/** 订单号 */
@property (nonatomic, strong) NSString *el;


@end
