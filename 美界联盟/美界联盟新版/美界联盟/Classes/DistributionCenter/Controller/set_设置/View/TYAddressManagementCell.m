//
//  TYAddressManagementCell.m
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYAddressManagementCell.h"

@interface TYAddressManagementCell()
//名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//设为默认按妞
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

@end

@implementation TYAddressManagementCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYAddressManagementCell";
    TYAddressManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYAddressManagementMdoel *)model{
    _model = model;
    self.nameLabel.text = model.dc;
    self.telLabel.text = model.dd;
    self.addressLabel.text = model.dg;
    
    if (model.dh == 2) {
        self.setBtn.selected = YES;
    }else{
        self.setBtn.selected = NO;
    }
}


//设为默认
- (IBAction)SetDefault {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickSetDefault:)]) {
        [_delegate ClickSetDefault:self.setBtn];
    }
}

//删除
- (IBAction)ClickDelete:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickDeleteAddress:)]) {
        [_delegate ClickDeleteAddress:sender];
    }
}

//编辑
- (IBAction)ClickEdit:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickEditAddress:)]) {
        [_delegate ClickEditAddress:sender];
    }
}

@end
