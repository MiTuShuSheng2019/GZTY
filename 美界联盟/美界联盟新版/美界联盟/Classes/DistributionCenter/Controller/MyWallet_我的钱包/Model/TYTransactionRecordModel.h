//
//  TYTransactionRecordModel.h
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYTransactionRecordModel : NSObject

/** 记录主键ID */
@property (nonatomic, assign) NSInteger ea;
/** 操作描述 1：下级充值增加（-）；2：下级充值扣减（+）；3：上级充值增加（+），4：上级充值扣减（-）；5：订单或流水出库完成（+）；6：下级退货（+） */
@property (nonatomic, strong) NSString *eb;
/** 操作类型 1：添加 2 扣减 */
@property (nonatomic, assign) NSInteger ec;
/** 时间 */
@property (nonatomic, strong) NSString *ed;
/** 操作金额 */
@property (nonatomic, assign) double ee;
/** 操作类型描述 */
@property (nonatomic, strong) NSString *ef;
/** 操作后金额 */
@property (nonatomic, assign) double eg;


@end
