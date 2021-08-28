//
//  TYForRecordCell.h
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYForRecord.h"

@interface TYForRecordCell : UITableViewCell

//创建
+(instancetype)CellTableView:(UITableView *)tableView;


/** TYForRecord */
@property (nonatomic, strong) TYForRecord *model;

@end
