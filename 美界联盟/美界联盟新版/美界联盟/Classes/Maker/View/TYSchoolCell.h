//
//  TYSchoolCell.h
//  美界联盟
//
//  Created by LY on 2017/11/18.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYMakConListModel.h"

@interface TYSchoolCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYMakConListModel */
@property (nonatomic, strong) TYMakConListModel *model;

@end
