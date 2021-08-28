//
//  TYMyInventoryCell.m
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMyInventoryCell.h"

@interface TYMyInventoryCell ()
//产品名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//剩余库存
@property (weak, nonatomic) IBOutlet UILabel *InventoryLabel;
//查看明细
@property (weak, nonatomic) IBOutlet UIButton *detailsBtn;


@end

@implementation TYMyInventoryCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYMyInventoryCell";
    TYMyInventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYStorageProdModel *)model{
    _model = model;
    self.nameLabel.text = model.m;
    self.InventoryLabel.text = [NSString stringWithFormat:@"剩余库存:%ld",model.f];
}

//产看明细
- (IBAction)SeeDetailProduction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickSeeDetailProduction:)]) {
        [_delegate ClickSeeDetailProduction:sender];
    }
}

@end
