//
//  TYMessageCell.h
//  美界联盟
//
//  Created by LY on 2017/10/26.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYManageModel.h"

@interface TYMessageCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYManageModel */
@property (nonatomic, strong) TYManageModel *model;


@end
