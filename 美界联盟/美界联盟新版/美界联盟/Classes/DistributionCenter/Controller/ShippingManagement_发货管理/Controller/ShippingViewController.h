//
//  ShippingViewController.h
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface ShippingViewController : TYBaseViewController

/** 0表示订单发货 1表示流水发货 */
@property (nonatomic, assign) NSInteger type;

@end
