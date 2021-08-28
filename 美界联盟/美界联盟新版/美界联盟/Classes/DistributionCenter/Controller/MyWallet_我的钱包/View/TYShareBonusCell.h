//
//  TYShareBonusCell.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYShareBonusModel.h"
#import "TYLuxuryCarYear.h"

@interface TYShareBonusCell : UITableViewCell

//季度
@property (weak, nonatomic) IBOutlet UILabel *quarterLabel;
//销售金额
@property (weak, nonatomic) IBOutlet UILabel *salesAmountLabel;
//我的分红
@property (weak, nonatomic) IBOutlet UILabel *myBonusLabel;

//创建
+(instancetype)CellTableView:(UITableView *)tableView;

/** TYShareBonusModel */
@property (nonatomic, strong) TYShareBonusModel *model;


/** 季度豪车奖励传此模型TYLuxuryCarYear */
@property (nonatomic, strong) TYLuxuryCarYear *carModel;


@end
