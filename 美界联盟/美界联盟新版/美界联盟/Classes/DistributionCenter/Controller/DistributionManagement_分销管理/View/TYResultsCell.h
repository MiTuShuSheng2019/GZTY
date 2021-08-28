//
//  TYResultsCell.h
//  美界联盟
//
//  Created by LY on 2018/9/14.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYMyOrderModel.h"

@interface TYResultsCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYTeamOrderCount */
@property (nonatomic, strong) TYTeamOrderCount *model;

@end
