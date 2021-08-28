//
//  TYOutboundCell.h
//  美界联盟
//
//  Created by LY on 2017/11/11.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYOutboundModel.h"

@interface TYOutboundCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYOutboundModel */
@property (nonatomic, strong) TYOutboundModel *model;

@end
