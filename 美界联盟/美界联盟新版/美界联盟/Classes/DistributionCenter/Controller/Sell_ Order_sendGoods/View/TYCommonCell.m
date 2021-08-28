//
//  TYCommonCell.m
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYCommonCell.h"

@interface TYCommonCell()
//商品封面图
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
//商品数量
@property (weak, nonatomic) IBOutlet UILabel *shopNumberLabel;
//商品价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation TYCommonCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYCommonCell";
    TYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.shopImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.shopImageView.clipsToBounds = YES;
    //适应retina屏幕
    [self.shopImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYCusSumModel *)model{
    _model = model;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.g]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.shopNameLabel.text = model.f;
    self.shopNumberLabel.text = [NSString stringWithFormat:@"X%ld",model.d];
    self.priceLabel.text = [NSString stringWithFormat:@"总金额￥%0.2lf",model.e];
}


-(void)setOrderPriceModel:(TYOrderPriceModel *)OrderPriceModel{
    _OrderPriceModel = OrderPriceModel;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,OrderPriceModel.ec]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.shopNameLabel.text = OrderPriceModel.eb;
    self.shopNumberLabel.text = [NSString stringWithFormat:@"X%ld",OrderPriceModel.ee];
    self.priceLabel.text = [NSString stringWithFormat:@"总金额￥%0.2lf",OrderPriceModel.ed];
}
@end
