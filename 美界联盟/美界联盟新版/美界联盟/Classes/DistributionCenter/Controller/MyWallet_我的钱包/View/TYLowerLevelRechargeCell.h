//
//  TYLowerLevelRechargeCell.h
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYRechargeModel.h"

@interface TYLowerLevelRechargeCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYRechargeModel */
@property (nonatomic, strong) TYRechargeModel *model;

@end
