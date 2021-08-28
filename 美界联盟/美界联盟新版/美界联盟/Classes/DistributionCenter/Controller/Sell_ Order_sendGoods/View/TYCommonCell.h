//
//  TYCommonCell.h
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCusSumModel.h"
#import "TYOrderPriceModel.h"

@interface TYCommonCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYCusSumModel 销售总额传此模型*/
@property (nonatomic, strong) TYCusSumModel *model;

/** TYOrderPriceModel 订单总额传此模型*/
@property (nonatomic, strong) TYOrderPriceModel *OrderPriceModel;


@end
