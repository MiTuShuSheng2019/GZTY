//
//  TYSendGoodsCell.h
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAwaitingModel.h"

@interface TYSendGoodsCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYAwaitingModel */
@property (nonatomic, strong) TYAwaitingModel *model;

@end
