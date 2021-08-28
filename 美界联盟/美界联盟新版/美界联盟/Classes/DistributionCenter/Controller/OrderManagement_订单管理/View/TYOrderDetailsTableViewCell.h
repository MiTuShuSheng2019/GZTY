//
//  TYOrderDetailsTableViewCell.h
//  美界APP
//
//  Created by TY-DENG on 17/8/5.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYMyOrderModel.h"
#import "TYMyOrderSubModel.h"
#import "TYStorageDetailModel.h"
#import "TYRetailOutStorageModel.h"
#import "TYConsumerAwaitingModel.h"
#import "TYSelectProduct.h"

@interface TYOrderDetailsTableViewCell : UITableViewCell


//创建cell
+(instancetype)CellTableView:(UITableView *)tableView;
/** TYMyOrderSubModel */
@property (nonatomic, strong) TYMyOrderSubModel *model;


/** 发货明细传此模型TYStorageDetailModel */
@property (nonatomic, strong) TYStorageDetailModel *detailModel;

/** 零售发货明细传此模型TYRetailOutStorageBigModel */
@property (nonatomic, strong) TYRetailOutStorageModel *retailModel;

/** 确认下单传此模型 TYSelectProduct */
@property (nonatomic, strong) TYSelectProduct *productModel;

/** 消费者登录传此模型TYConsumerAwaitingModel */
@property (nonatomic, strong) TYConsumerAwaitingModel *consumerModel;



@end
