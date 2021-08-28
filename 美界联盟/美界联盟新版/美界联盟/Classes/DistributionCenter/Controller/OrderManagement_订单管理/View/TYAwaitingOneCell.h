//
//  TYAwaitingOneCell.h
//  美界app
//
//  Created by LY on 2017/10/20.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYConsumerAwaitingBigModel.h"
#import "TYMyOrderModel.h"

@protocol TYAwaitingOneCellDelegate <NSObject>

-(void)FirstLookDetail:(UIButton *)btn;

-(void)LookLogistic:(UIButton *)btn;

-(void)LookDetail:(UIButton *)btn;

@end

@interface TYAwaitingOneCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** delegate */
@property (nonatomic, weak) id <TYAwaitingOneCellDelegate> delegate;


/** TYConsumerAwaitingBigModel */
@property (nonatomic, strong) TYConsumerAwaitingBigModel *model;
//查看详情
@property (weak, nonatomic) IBOutlet UIButton *LookDetailBtn;

//查看物流
@property (weak, nonatomic) IBOutlet UIButton *logisticBtn;
//查看详情
@property (weak, nonatomic) IBOutlet UIButton *detalBtn;

//状态
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

/** 分销商登录我的订单传此模型TYMyOrderModel */
@property (nonatomic, strong) TYMyOrderModel *MyOrderModel;

@end
