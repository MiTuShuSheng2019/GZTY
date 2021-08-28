//
//  TYShopCartCell.m
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShopCartCell.h"

@interface TYShopCartCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@end

@implementation TYShopCartCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYShopCartCell";
    TYShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
//点击选择
- (IBAction)ClickChooseButton:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(ClickChoose:)]) {
        [_delegate ClickChoose:sender];
    }
}

-(void)setModel:(TYHotProductModel *)model{
    _model = model;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoUrl,model.ee]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.shopNameLabel.text = model.eb;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.ec];
    self.numberLabel.text = [NSString stringWithFormat:@"x%ld",(long)model.shopNumber];
    if (model.isSelected == YES) {
        self.chooseBtn.selected = YES;
    }else{
        self.chooseBtn.selected = NO;
    }
}

@end
