//
//  TYTeamTwoCell.h
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYResultDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYTeamTwoCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYResultDetailModel */
@property (nonatomic, strong) TYResultDetailModel *model;

@end

NS_ASSUME_NONNULL_END
