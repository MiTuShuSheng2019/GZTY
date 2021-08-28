//
//  TYMyExperienceStoreCell.m
//  美界联盟
//
//  Created by LY on 2017/11/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMyExperienceStoreCell.h"

@interface TYMyExperienceStoreCell ()

//预约人
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//预约手机
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//预约人数
@property (weak, nonatomic) IBOutlet UILabel *peopleNumeberLabel;
//服务项目
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;


@end

@implementation TYMyExperienceStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYMyExperienceStoreCell";
    TYMyExperienceStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
    }
    return cell;
}

-(void)setModel:(TYExpOrderListModel *)model{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"预约人：%@", model.ec];
    self.phoneLabel.text = [NSString stringWithFormat:@"预约手机：%@", model.eb];
    self.peopleNumeberLabel.text = [NSString stringWithFormat:@"预约人数：%ld", model.eh];
    self.serviceLabel.text = [NSString stringWithFormat:@"服务项目：%@", model.ei];
}

//接收
- (IBAction)reception:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickReception:)]) {
        [_delegate ClickReception:sender];
    }
}

//取消
- (IBAction)cancel:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickCancel:)]) {
        [_delegate ClickCancel:sender];
    }
}

@end
