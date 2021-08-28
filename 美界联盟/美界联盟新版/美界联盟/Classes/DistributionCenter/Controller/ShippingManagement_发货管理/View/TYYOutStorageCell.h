//
//  TYYOutStorageCell.h
//  美界联盟
//
//  Created by LY on 2017/11/10.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYOutStorageModel.h"

@interface TYYOutStorageCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYOutStorageModel */
@property (nonatomic, strong) TYOutStorageModel *model;

@end
