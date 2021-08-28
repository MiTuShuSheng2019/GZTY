//
//  TYDistributorsCell.h
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYDistributorsModel.h"

@interface TYDistributorsCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYDistributorsModel */
@property (nonatomic, strong) TYDistributorsModel *model;

@end
