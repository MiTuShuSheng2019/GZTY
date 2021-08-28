//
//  TYCarTwoCell.h
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCarResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYCarTwoCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;
/** TYCarResultModel */
@property (nonatomic, strong) TYCarResultModel *model;

@end

NS_ASSUME_NONNULL_END
