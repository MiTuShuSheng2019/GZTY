//
//  TYRechargeModel.h
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYRechargeModel : UIView

/** 记录主键ID */
@property (nonatomic, assign) NSInteger ea;
/** 操作描述 1：下级充值增加（-）；2：下级充值扣减（+）；3：上级充值增加（+），4：上级充值扣减（-）；5：订单或流水出库完成（+）；6：下级退货（+） */
@property (nonatomic, strong) NSString *eb;
/** 操作类型 1：添加 2 扣减 */
@property (nonatomic, strong) NSString *ec;
/** 时间 */
@property (nonatomic, strong) NSString *ed;
/** 充值后余额 */
@property (nonatomic, assign) double ee;
/** 充值金额 */
@property (nonatomic, assign) double ef;


/** 分销商名称 */
@property (nonatomic, strong) NSString *eg;
/** 分销商等级 */
@property (nonatomic, strong) NSString *eh;
/** 分销商电话 */
@property (nonatomic, strong) NSString *ei;

@end
