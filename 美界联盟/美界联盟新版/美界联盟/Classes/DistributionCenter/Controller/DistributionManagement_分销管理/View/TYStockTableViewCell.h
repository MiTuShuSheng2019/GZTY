//
//  TYStockTableViewCell.h
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYStockModel.h"

@interface TYStockTableViewCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYStockModel */
@property (nonatomic, strong) TYStockModel *model;

@end
