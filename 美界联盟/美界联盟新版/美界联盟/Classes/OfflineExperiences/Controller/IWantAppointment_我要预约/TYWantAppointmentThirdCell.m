//
//  TYWantAppointmentThirdCell.m
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYWantAppointmentThirdCell.h"

@implementation TYWantAppointmentThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _RemarkTextView.layer.borderColor = RGB(238, 238, 238).CGColor;
    _RemarkTextView.layer.borderWidth = 1;
    _RemarkTextView.layer.cornerRadius = 5;
    _RemarkTextView.layer.masksToBounds = YES;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYWantAppointmentThirdCell";
    TYWantAppointmentThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
