//
//  TYWantAppointmentCell.m
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYWantAppointmentCell.h"
#import "SZCalendarPicker.h"

@interface TYWantAppointmentCell ()<UITextFieldDelegate>

@end

@implementation TYWantAppointmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.backgroundColor = RGB(183, 183, 183);
    self.timeTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYWantAppointmentCell";
    TYWantAppointmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
    }
    return cell;
}

#pragma mark -- <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self endEditing:YES];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:window];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, KScreenWidth, 352);
    if (textField == self.timeTextField) {
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
            self.timeTextField.text = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
        };
    }

    return NO;
}

@end
