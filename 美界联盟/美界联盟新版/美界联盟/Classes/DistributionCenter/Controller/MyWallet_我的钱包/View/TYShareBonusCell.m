//
//  TYShareBonusCell.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShareBonusCell.h"

@interface TYShareBonusCell()


@end

@implementation TYShareBonusCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYShareBonusCell";
    TYShareBonusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
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

-(void)setModel:(TYShareBonusModel *)model{
    _model = model;
    self.quarterLabel.text = [NSString stringWithFormat:@"第%ld季度",model.db];
    self.salesAmountLabel.text = [NSString stringWithFormat:@"￥%0.2lf",model.dc];
    self.myBonusLabel.text = [NSString stringWithFormat:@"￥%0.2lf",model.dd];
}

-(void)setCarModel:(TYLuxuryCarYear *)carModel{
    _carModel = carModel;
    self.quarterLabel.text = [NSString stringWithFormat:@"%@年",carModel.da];
    self.salesAmountLabel.text = [NSString stringWithFormat:@"第%ld季度",carModel.db];
    self.myBonusLabel.text = [NSString stringWithFormat:@"￥%@",carModel.dc];
}

@end
