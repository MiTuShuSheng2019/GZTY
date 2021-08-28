//
//  TYRechargeCell.m
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYRechargeCell.h"

@interface TYRechargeCell()
//名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//余额
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
//充值
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation TYRechargeCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYRechargeCell";
    TYRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYRechargeModel *)model{
    _model = model;
    self.nameLabel.text = model.eb;
    self.balanceLabel.text = [NSString stringWithFormat:@"剩余余额：￥%0.2lf",model.ee];
    if ([model.ec isEqualToString:@"新增"]) {//1：添加 2 扣减
        self.rechargeLabel.text = [NSString stringWithFormat:@"+￥%0.2lf",model.ef];
        self.rechargeLabel.textColor = RGB(28, 45, 251);
    }else{
        self.rechargeLabel.text = [NSString stringWithFormat:@"-￥%0.2lf",model.ef];
        self.rechargeLabel.textColor = [UIColor redColor];
    }
    self.timeLabel.hidden = YES;
}


-(void)setRecordModel:(TYTransactionRecordModel *)RecordModel{
    _RecordModel = RecordModel;
    self.nameLabel.text = RecordModel.eb;
    self.balanceLabel.text = [NSString stringWithFormat:@"剩余余额：￥%0.2lf",RecordModel.eg];
    if (RecordModel.ec == 1) {//1：添加 2 扣减
        self.rechargeLabel.text = [NSString stringWithFormat:@"+￥%0.2lf",RecordModel.ee];
        self.rechargeLabel.textColor = RGB(28, 45, 251);
    }else{
        self.rechargeLabel.text = [NSString stringWithFormat:@"-￥%0.2lf",RecordModel.ee];
        self.rechargeLabel.textColor = [UIColor redColor];
    }
    self.timeLabel.text = RecordModel.ed;
}
@end
