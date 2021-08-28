//
//  TYDeliveryRecordCell.h
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYDeliveryRecordModel.h"
#import "TYMyOrderModel.h"

@protocol TYDeliveryRecordCellDelegate <NSObject>

//查看详情
-(void)ClickLookDetail:(UIButton *)btn;

//查看物流
-(void)ClickLookLogistic:(UIButton *)btn;


@end

@interface TYDeliveryRecordCell : UITableViewCell

//创建
+(instancetype)CellTableView:(UITableView *)tableView;

/** TYDeliveryRecordModel */
@property (nonatomic, strong) TYDeliveryRecordModel *model;

/** delegate */
@property (nonatomic, weak) id <TYDeliveryRecordCellDelegate> delegate;

/** 订单发货传此模型TYAwaitingModel */
@property (nonatomic, strong) TYMyOrderModel *awModel;

@end
