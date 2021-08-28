//
//  TYStockTableViewCell.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYStockTableViewCell.h"

@interface TYStockTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;

@end

@implementation TYStockTableViewCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYStockTableViewCell";
    TYStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYStockModel *)model{
    _model = model;
    self.nameLabel.text = model.q;
    self.stockLabel.text = [NSString stringWithFormat:@"剩余库存:%ld",model.f];
}

@end
