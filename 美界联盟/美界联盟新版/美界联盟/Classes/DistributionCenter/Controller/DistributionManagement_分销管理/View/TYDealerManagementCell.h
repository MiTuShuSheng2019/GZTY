//
//  TYDealerManagementCell.h
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYLowerCusModel.h"
#import "TYReApplyModel.h"

@protocol TYDealerManagementCellDelegate <NSObject>

-(void)ClickThrough:(UIButton *)btn;

@end

@interface TYDealerManagementCell : UITableViewCell

//创建
+(instancetype)CellTableView:(UITableView *)tableView;

/** delegate */
@property (nonatomic, weak) id <TYDealerManagementCellDelegate> delegate;

/** TYLowerCusModel */
@property (nonatomic, strong) TYLowerCusModel *model;

//是否通过
@property (weak, nonatomic) IBOutlet UIButton *isThroughBtn;

/** 推荐升级-->已推荐模块传此模型TYReApplyModel */
@property (nonatomic, strong) TYReApplyModel *applyModel;

@end
