//
//  TYWantAppointmentTwoCell.m
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYWantAppointmentTwoCell.h"

@interface TYWantAppointmentTwoCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end

@implementation TYWantAppointmentTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYWantAppointmentTwoCell";
    TYWantAppointmentTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

//赋值
-(void)setModel:(TYServiceModel *)model{
    _model = model;
    self.nameLabel.text = [TYValidate IsNotNull:model.sb];
    
    if (model.isSelected == YES) {
        self.chooseBtn.selected = YES;
    }else{
        self.chooseBtn.selected = NO;
    }
}

//选择
- (IBAction)choose:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickChoose:)]) {
        [_delegate ClickChoose:sender];
    }
}

@end
