//
//  TYTeamManagementCell.h
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTeamManagementModel.h"

@interface TYTeamManagementCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYTeamManagementModel */
@property (nonatomic, strong) TYTeamManagementModel *model;

@end
