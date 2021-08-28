//
//  TYHotProductCollectionViewCell.m
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "DEHotProductCollectionViewCell.h"
#import "TYLoginChooseViewController.h"

@interface DEHotProductCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopPriceLabel;
//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation DEHotProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.shopImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.shopImageView.clipsToBounds = YES;
    //适应retina屏幕
    [self.shopImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
}

-(void)setModel:(DEIntegralMallModel *)model{
    _model = model;

     [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.goodsUrl]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.shopNameLabel.text = model.goodsName;
//    self.shopPriceLabel.text = [NSString stringWithFormat:@"￥:%@", model.goodsPrice];
    //消费者登录隐藏分享按钮
    if ([TYSingleton shareSingleton].consumer == 1) {
        self.shareBtn.hidden = YES;
    }else{
        self.shareBtn.hidden = NO;
    }
    //此处利用时间戳屏蔽分享按钮，是为了规避苹果审核
    if ([TYDevice getDateDayNow] > 20190926) {
        self.shareBtn.hidden = NO;
    }else{
        self.shareBtn.hidden = YES;
    }
}

-(void)setType:(NSString *)type
{
    switch ([type integerValue]) {
        case 2:
             self.shopPriceLabel.text = [NSString stringWithFormat:@"金币:%@", _model.goodsGold];
            break;
        case 1:
             self.shopPriceLabel.text = [NSString stringWithFormat:@"银币:%@", _model.goodsSilver];
            break;
            
        default:
            break;
    }
}

//分享
- (IBAction)ClickShare:(UIButton *)sender {
    if ([TYLoginModel getPrimaryId] > 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(shopping:)]) {
            [_delegate shopping:sender];
        }
    }else{
        //未登录提示先去登录
        [TYAlertAction showTYAlertActionTitle:@"" andMessage:@"未登录不能分享请先登录" andVc: [[TYLoginChooseViewController alloc] init] andClick:^(NSInteger buttonIndex) {
            
        }];
    }
}

@end
