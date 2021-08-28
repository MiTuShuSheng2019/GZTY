//
//  TYHasExperienceCell.h
//  美界联盟
//
//  Created by LY on 2017/11/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYExpOrderListModel.h"

@interface TYHasExperienceCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYExpOrderListModel */
@property (nonatomic, strong) TYExpOrderListModel *model;

@end
