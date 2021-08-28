//
//  TYDeliveryRecordCell.m
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDeliveryRecordCell.h"

@interface TYDeliveryRecordCell ()
//流水号
@property (weak, nonatomic) IBOutlet UILabel *StreamNumberLabel;
//分销商
@property (weak, nonatomic) IBOutlet UILabel *distributorsLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//总计
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
//查看物流
@property (weak, nonatomic) IBOutlet UIButton *logisticsBtn;
//查看详情
@property (weak, nonatomic) IBOutlet UIButton *detailsBtn;


@end

@implementation TYDeliveryRecordCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYDeliveryRecordCell";
    TYDeliveryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailsBtn.layer.borderColor = RGB(236, 236, 236).CGColor;
    self.logisticsBtn.layer.borderColor = RGB(236, 236, 236).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)setModel:(TYDeliveryRecordModel *)model{
    _model = model;
    self.StreamNumberLabel.text = [NSString stringWithFormat:@"流水号：%@",model.eb];
    self.distributorsLabel.text = [NSString stringWithFormat:@"分销商：%@",model.ec];
    self.telLabel.text = [NSString stringWithFormat:@"手机：%@",model.ed];
    self.timeLabel.text = model.ee;
    self.totalLabel.text = [NSString stringWithFormat:@"共%ld件商品，总计：￥%0.2lf",model.ef,model.eg];
}

-(void)setAwModel:(TYMyOrderModel *)awModel{
    _awModel = awModel;
    self.StreamNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",awModel.eb];
    self.distributorsLabel.text = [NSString stringWithFormat:@"姓名：%@",awModel.eg];
    self.telLabel.text = [NSString stringWithFormat:@"手机：%@",awModel.ei];
    self.timeLabel.text = awModel.ee;
    self.totalLabel.text = [NSString stringWithFormat:@"共%ld件商品，总计：￥%@",awModel.ed,awModel.ec];
    [self.logisticsBtn setTitle:@"发货" forState:UIControlStateNormal];
}

//物流
- (IBAction)LookLogistics:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickLookLogistic:)]) {
        [_delegate ClickLookLogistic:sender];
    }
}

//详情
- (IBAction)LookDetails:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickLookDetail:)]) {
        [_delegate ClickLookDetail:sender];
    }
}
@end
