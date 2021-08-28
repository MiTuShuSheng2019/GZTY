//
//  TYWantAppointmentCell.h
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWantAppointmentCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

//封面图
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//预约人
@property (weak, nonatomic) IBOutlet UITextField *peopleTextField;
//预约电话
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//预约人数
@property (weak, nonatomic) IBOutlet UITextField *peopleNumberTextField;
//预约时间
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@end
