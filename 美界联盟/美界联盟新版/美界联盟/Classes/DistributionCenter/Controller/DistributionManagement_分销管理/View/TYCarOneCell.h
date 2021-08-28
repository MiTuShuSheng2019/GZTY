//
//  TYCarOneCell.h
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYRebateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYCarOneCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYRebateModel */
@property (nonatomic, strong) TYRebateModel *model;

@end

NS_ASSUME_NONNULL_END
