//
//  TYRetailRevenueCell.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYRetailRevenueCell.h"
#import "TYRetailRevenueModel.h"

@interface TYRetailRevenueCell()
//流水号
@property (weak, nonatomic) IBOutlet UILabel *StreamNumberLabel;
//产品名称
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
//金额
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation TYRetailRevenueCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYRetailRevenueCell";
    TYRetailRevenueCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYRetailRevenueModel *)model{
    _model = model;
    self.StreamNumberLabel.text = [NSString stringWithFormat:@"流水号：%@",model.da];
    self.shopNameLabel.text = [NSString stringWithFormat:@"收货人：%@",model.dc];
    self.amountLabel.text = [NSString stringWithFormat:@"金额：￥%@",model.db];
}

@end
