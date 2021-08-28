//
//  TYRebateManagementTwoCell.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAmountModel.h"

@protocol TYRebateManagementTwoCellDelegate <NSObject>
//点击我的分红
-(void)ClickMyDividend:(UIButton *)btn;

//点击团队分红
-(void)ClickTeamDividend:(UIButton *)btn;

@end


@interface TYRebateManagementTwoCell : UITableViewCell

//创建
+(instancetype)CellTableView:(UITableView *)tableView;

/** delegate */
@property (nonatomic, weak) id <TYRebateManagementTwoCellDelegate> delegate;

/** TYAmountModel */
@property (nonatomic, strong) TYAmountModel *model;


@end
