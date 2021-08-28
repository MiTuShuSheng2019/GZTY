//
//  TYSendGoodsCell.m
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYSendGoodsCell.h"

@interface TYSendGoodsCell()
//订单号
@property (weak, nonatomic) IBOutlet UILabel *OrderNumberLabel;
//收货人
@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;
//金额
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TYSendGoodsCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYSendGoodsCell";
    TYSendGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYAwaitingModel *)model{
    _model = model;
    self.OrderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",model.eb];
    self.consigneeLabel.text = [NSString stringWithFormat:@"收货人：%@",model.eg];
    self.priceLabel.text = [NSString stringWithFormat:@"金额：%@",model.ec];
    self.timeLabel.text = model.ee;
}

@end
