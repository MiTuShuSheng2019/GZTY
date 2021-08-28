//
//  TYShopCollectionCell.m
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShopCollectionCell.h"

@interface TYShopCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopPriceLabel;

@end


@implementation TYShopCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.shopImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.shopImageView.clipsToBounds = YES;
    //适应retina屏幕
    [self.shopImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
}

-(void)setModel:(TYHotProductModel *)model{
    _model = model;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.ee]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.shopPriceLabel.text = [NSString stringWithFormat:@"产品价：%@", model.ec];
}

@end
