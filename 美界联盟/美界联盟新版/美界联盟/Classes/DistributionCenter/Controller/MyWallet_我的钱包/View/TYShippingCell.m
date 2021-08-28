//
//  TYShippingCell.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShippingCell.h"

@interface TYShippingCell()
//流水号
@property (weak, nonatomic) IBOutlet UILabel *StreamNumberLabel;
//金额
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation TYShippingCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYShippingCell";
    TYShippingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYShippingModel *)model{
    _model = model;
    self.StreamNumberLabel.text = [NSString stringWithFormat:@"流水号：%@",[TYValidate IsNotNull:model.da]];
    self.amountLabel.text = [NSString stringWithFormat:@"金额：￥%@",model.db];;
}

@end
