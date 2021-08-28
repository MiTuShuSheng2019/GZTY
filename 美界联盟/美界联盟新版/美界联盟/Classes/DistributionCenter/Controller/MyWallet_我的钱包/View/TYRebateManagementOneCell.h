//
//  TYRebateManagementOneCell.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYDiffPriceModel.h"

@interface TYRebateManagementOneCell : UITableViewCell

//创建
+(instancetype)CellTableView:(UITableView *)tableView;

/** TYDiffPriceModel */
@property (nonatomic, strong) TYDiffPriceModel *model;

@end
