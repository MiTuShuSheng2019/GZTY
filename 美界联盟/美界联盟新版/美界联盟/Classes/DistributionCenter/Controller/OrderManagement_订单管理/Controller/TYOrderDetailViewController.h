//
//  TYOrderDetailViewController.h
//  美界app
//
//  Created by LY on 2017/10/21.
//  Copyright © 2017年 Lin. All rights reserved.
//  订单详情

#import "TYBaseViewController.h"
#import "TYMyOrderModel.h"
#import "TYConsumerAwaitingBigModel.h"

@interface TYOrderDetailViewController : TYBaseViewController

/** 接收传值 */
@property (nonatomic, strong) TYMyOrderModel *model;

/** 消费者登录传此模型 */
@property (nonatomic, strong) TYConsumerAwaitingBigModel *consumerModel;

@end
