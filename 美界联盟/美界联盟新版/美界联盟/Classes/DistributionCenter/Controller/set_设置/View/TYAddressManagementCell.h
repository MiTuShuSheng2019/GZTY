//
//  TYAddressManagementCell.h
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAddressManagementMdoel.h"

@protocol TYAddressManagementCellDelegate  <NSObject>
//设为默认
- (void)ClickSetDefault:(UIButton *)btn;
//删除
- (void)ClickDeleteAddress:(UIButton *)btn;
//编辑
- (void)ClickEditAddress:(UIButton *)btn;

@end

@interface TYAddressManagementCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYAddressManagementMdoel */
@property (nonatomic, strong) TYAddressManagementMdoel *model;

/** delegate */
@property (nonatomic, weak) id <TYAddressManagementCellDelegate> delegate;

@end
