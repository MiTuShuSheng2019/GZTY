//
//  TYBillDetailCell.h
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYBillDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYBillDetailCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** 模型 */
@property (nonatomic, strong) TYBillDetailModel *model;


@end

NS_ASSUME_NONNULL_END
