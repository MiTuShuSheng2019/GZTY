//
//  TYRetailDeliveryCell.m
//  美界联盟
//
//  Created by LY on 2017/11/11.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYRetailDeliveryCell.h"

@interface TYRetailDeliveryCell ()


//流水号
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//创建时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//总计
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

//查看详情
@property (weak, nonatomic) IBOutlet UIButton *detailsBtn;

@end



@implementation TYRetailDeliveryCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYRetailDeliveryCell";
    TYRetailDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
     self.detailsBtn.layer.borderColor = RGB(236, 236, 236).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYTYRetailOutStorageBigModel *)model{
    _model = model;
    TYRetailOutStorageModel *subModel = [model.f firstObject];
    self.numberLabel.text = [NSString stringWithFormat:@"流水号：%@", subModel.fc];
    self.timeLabel.text = [NSString stringWithFormat:@"创建时间：%@", subModel.fg];
    self.totalLabel.text = [NSString stringWithFormat:@"共%ld件商品，总计：￥%0.2lf",model.e,model.g];
}

//查看详情
- (IBAction)details:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickLookDetail:)]) {
        [_delegate ClickLookDetail:sender];
    }
}
@end
