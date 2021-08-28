//
//  TYOfflineExperienceTableViewCell.h
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYExpCenterModel.h"

@interface TYOfflineExperienceTableViewCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYExpCenterModel */
@property (nonatomic, strong) TYExpCenterModel *model;


@end
