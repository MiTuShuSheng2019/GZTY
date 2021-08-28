//
//  TYWantAppointmentTwoCell.h
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYServiceModel.h"

@protocol TYWantAppointmentTwoCellDeledate <NSObject>

//点击选择
-(void)ClickChoose:(UIButton *)chooseBtn;

@end

@interface TYWantAppointmentTwoCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYServiceModel */
@property (nonatomic, strong) TYServiceModel *model;

/** TYWantAppointmentTwoCellDeledate */
@property (nonatomic, weak) id <TYWantAppointmentTwoCellDeledate> delegate;

@end
