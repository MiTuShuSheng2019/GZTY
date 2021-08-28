//
//  TYOutboundCell.m
//  美界联盟
//
//  Created by LY on 2017/11/11.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYOutboundCell.h"

@interface TYOutboundCell ()

//产品名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//订单数量
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
//出库数量
@property (weak, nonatomic) IBOutlet UILabel *outboundNumberLabel;

@end

@implementation TYOutboundCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYOutboundCell";
    TYOutboundCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYOutboundModel *)model{
    _model = model;
    self.nameLabel.text = model.f;
    self.orderNumberLabel.text = [NSString stringWithFormat:@"%ld",model.d];
    self.outboundNumberLabel.text = [NSString stringWithFormat:@"%ld",model.e];
}
@end
