//
//  TYLuxuryCarCell.h
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYLuxuryEventDetail.h"

@interface TYLuxuryCarCell : UITableViewCell

//创建
+(instancetype)CellTableView:(UITableView *)tableView;

/** TYLuxuryEventDetail */
@property (nonatomic, strong) TYLuxuryEventDetail *model;

/** 选择奖品传此模型TYLuxuryEventDetail */
@property (nonatomic, strong) TYLuxuryEventDetail *DetailModel;

@end
