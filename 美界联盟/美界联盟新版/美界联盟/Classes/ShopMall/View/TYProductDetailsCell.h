//
//  TYProductDetailsCell.h
//  美界联盟
//
//  Created by LY on 2017/10/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYDetailsModel.h"

@interface TYProductDetailsCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYDetailsModel */
@property (nonatomic, strong) TYDetailsModel *model;

@end
