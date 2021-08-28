//
//  TYReservationCell.h
//  美界联盟
//
//  Created by LY on 2017/11/29.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYExpOrderListModel.h"


@protocol TYReservationCellDelegate <NSObject>
//查看详情
-(void)ClicklookDetails:(UIButton *)btn;
//导航
-(void)ClickNavigation:(UIButton *)btn;
//电话
-(void)ClickPhone:(UIButton *)btn;
//评论
-(void)ClickComment:(UIButton *)btn;

@end

@interface TYReservationCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;


/** TYExpOrderListModel */
@property (nonatomic, strong) TYExpOrderListModel *model;

/** 预约详情传此模型TYExpOrderListModel */
@property (nonatomic, strong) TYExpOrderListModel *detailModel;

/** delegate */
@property (nonatomic, weak) id <TYReservationCellDelegate> delegate;


@end
