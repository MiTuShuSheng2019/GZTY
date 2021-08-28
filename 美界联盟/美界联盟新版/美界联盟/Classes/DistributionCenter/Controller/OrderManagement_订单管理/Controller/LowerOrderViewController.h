//
//  LowerOrderViewController.h
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface LowerOrderViewController : TYBaseViewController

/** 订单状态 -1全部 1未审核,2:审核通过;3:未通过;4:订单出库;5:订单入库;6:订单完成;7:订单作废 */
@property (nonatomic, assign) NSInteger type;

@end
