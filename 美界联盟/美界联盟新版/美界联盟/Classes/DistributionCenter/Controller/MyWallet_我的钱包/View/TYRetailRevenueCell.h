//
//  TYRetailRevenueCell.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYRetailRevenueModel;
@interface TYRetailRevenueCell : UITableViewCell

//创建
+(instancetype)CellTableView:(UITableView *)tableView;

/** TYRetailRevenueModel */
@property (nonatomic, strong) TYRetailRevenueModel *model;

@end
