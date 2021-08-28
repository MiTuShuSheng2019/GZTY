//
//  TYMyExperienceStoreCell.h
//  美界联盟
//
//  Created by LY on 2017/11/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYExpOrderListModel.h"

@protocol TYMyExperienceStoreCellDelegate <NSObject>
//预约
-(void)ClickReception:(UIButton *)btn;
//取消
-(void)ClickCancel:(UIButton *)btn;

@end


@interface TYMyExperienceStoreCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYExpOrderListModel */
@property (nonatomic, strong) TYExpOrderListModel *model;

/** delegate */
@property (nonatomic, weak) id <TYMyExperienceStoreCellDelegate> delegate;

@end
