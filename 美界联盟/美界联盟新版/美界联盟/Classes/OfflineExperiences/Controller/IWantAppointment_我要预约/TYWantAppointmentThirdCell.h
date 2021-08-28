//
//  TYWantAppointmentThirdCell.h
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWantAppointmentThirdCell : UITableViewCell

//备注
@property (weak, nonatomic) IBOutlet UITextView *RemarkTextView;

+(instancetype)CellTableView:(UITableView *)tableView;

@end
