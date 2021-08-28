//
//  TYOrderDetailsTableViewCell.m
//  美界APP
//
//  Created by TY-DENG on 17/8/5.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYOrderDetailsTableViewCell.h"

@interface TYOrderDetailsTableViewCell ()
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
//商品图片的宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productImageViewW;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//商品价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//商品数量
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation TYOrderDetailsTableViewCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYOrderDetailsTableViewCell";
    TYOrderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYMyOrderSubModel *)model{
    _model = model;
   
    if (model.IntergralType == 1) {
        self.priceLabel.text = [NSString stringWithFormat:@"银币 %ld", model.Intergral];
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.smmjProductUrl]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        self.nameLabel.text = model.smmjProductName;
    } else if (model.IntergralType == 2) {
        self.priceLabel.text = [NSString stringWithFormat:@"金币 %ld", model.Intergral];
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.smmjProductUrl]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        self.nameLabel.text = model.smmjProductName;
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2lf", model.eke];
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.ekb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        self.nameLabel.text = model.ekc;
    }
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2lf", model.eke];
//    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.ekb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
//    self.nameLabel.text = model.ekc;
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", model.ekf];
}

-(void)setDetailModel:(TYStorageDetailModel *)detailModel{
    _detailModel = detailModel;
    self.productImageView.hidden = YES;
    self.productImageViewW.constant = 0;
    
    self.nameLabel.text = detailModel.ec;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2lf", detailModel.eg];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", detailModel.ed];
}

-(void)setRetailModel:(TYRetailOutStorageModel *)retailModel{
    _retailModel = retailModel;
   
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,retailModel.fn]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = retailModel.fm;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2lf", retailModel.fo];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", retailModel.fl];
}

-(void)setProductModel:(TYSelectProduct *)productModel{
    _productModel = productModel;
    switch (productModel.type) {
        case 2:
            self.priceLabel.text = [NSString stringWithFormat:@"金币 %@", productModel.ee];
            break;
            
        case 1:
            self.priceLabel.text = [NSString stringWithFormat:@"银币 %@", productModel.ee];
            break;
            
        default:
            self.priceLabel.text = [NSString stringWithFormat:@"￥ %@", productModel.ee];
            break;
    }
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,productModel.eb]] placeholderImage:[UIImage imageNamed:@"image_default_loading.png"]];
    self.nameLabel.text = [TYValidate IsNotNull:productModel.ec];
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", productModel.ee];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", productModel.countNumber];
}

//消费者登录
-(void)setConsumerModel:(TYConsumerAwaitingModel *)consumerModel{
    _consumerModel = consumerModel;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,consumerModel.def]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = consumerModel.deg;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2lf", consumerModel.deh];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", consumerModel.dec];
}

@end
