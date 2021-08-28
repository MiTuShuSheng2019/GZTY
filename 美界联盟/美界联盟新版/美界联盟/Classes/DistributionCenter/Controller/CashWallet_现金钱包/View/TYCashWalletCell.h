//
//  TYCashWalletCell.h
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCashModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickButton)(NSInteger tag);
@interface TYCashWalletCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;
/** 回调 */
@property (nonatomic, copy) ClickButton clickTheButtonBlock;
/** TYCashModel */
@property (nonatomic, strong) TYCashModel *model;

@end

NS_ASSUME_NONNULL_END
