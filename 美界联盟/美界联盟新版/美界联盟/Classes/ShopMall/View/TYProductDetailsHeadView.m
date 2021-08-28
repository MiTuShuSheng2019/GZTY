//
//  TYProductDetailsHeadView.m
//  美界联盟
//
//  Created by LY on 2017/10/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYProductDetailsHeadView.h"


@interface TYProductDetailsHeadView ()

//商品名称
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *shopPriceLabel;

@end


@implementation TYProductDetailsHeadView

+(instancetype)CreatTYProductDetailsHeadView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

-(void)setModel:(TYHotProductModel *)model{
    _model = model;
    self.shopNameLabel.text = model.eb;
    self.shopPriceLabel.text = [NSString stringWithFormat:@"产品价：￥%@",model.ec];
}

-(void)setIModel:(DEIntegralMallModel *)IModel type:(NSInteger)type
{
    self.shopNameLabel.text = IModel.goodsName;
    
    switch (type) {
        case 2:
            self.shopPriceLabel.text = [NSString stringWithFormat:@"金币:%@", IModel.goodsGold];
            break;
        case 1:
            self.shopPriceLabel.text = [NSString stringWithFormat:@"银币:%@", IModel.goodsSilver];
            break;
            
        default:
            break;
    }
}

@end
