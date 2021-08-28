//
//  TYAwaitingDeliveryViewController.h
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYAwaitingDeliveryViewController : TYBaseViewController

/** 1表示从待收货进入，2表示待发货，3表示已完成 */
@property (nonatomic, assign) NSInteger isWho;

@end
