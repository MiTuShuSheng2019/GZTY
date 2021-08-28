//
//  TYLowerLevelRechargeCell.m
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLowerLevelRechargeCell.h"

@interface TYLowerLevelRechargeCell()
//名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//余额
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
//说明
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TYLowerLevelRechargeCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYLowerLevelRechargeCell";
    TYLowerLevelRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
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
    self.balanceLabel.text = [NSString stringWithFormat:@"￥%0.2lf",model.ef];
    self.contentLabel.text = model.eg;
    self.timeLabel.text = model.ed;
}
@end
