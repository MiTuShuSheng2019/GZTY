//
//  TYRebateManagementThreeCell.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYEventModel.h"

@interface TYRebateManagementThreeCell : UITableViewCell

//创建
+(instancetype)CellTableView:(UITableView *)tableView;

/** TYEventModel */
@property (nonatomic, strong) TYEventModel *model;

//销售总额
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
