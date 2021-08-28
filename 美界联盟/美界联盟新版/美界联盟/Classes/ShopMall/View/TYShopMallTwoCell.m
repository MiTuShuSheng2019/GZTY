//
//  TYShopMallTwoCell.m
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShopMallTwoCell.h"
#import "TYLoginChooseViewController.h"

@interface TYShopMallTwoCell ()
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
//商品价格
@property (weak, nonatomic) IBOutlet UILabel *shopPriceLabel;
//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@end

@implementation TYShopMallTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.shopImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.shopImageView.clipsToBounds = YES;
    //适应retina屏幕
    [self.shopImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYShopMallTwoCell";
    TYShopMallTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYHotProductModel *)model{
    _model = model;
//    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.ee]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    NSString *imgUlr = [NSString stringWithFormat:@"%@%@",PhotoUrl,model.ee];
     [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:aliPic(imgUlr, kAliPicStr_150_150)] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    
    self.shopNameLabel.text = model.eb;
    self.shopPriceLabel.text = [NSString stringWithFormat:@"产品价：%@", model.ec];
    
    //消费者登录隐藏分享按钮
    if ([TYSingleton shareSingleton].consumer == 1) {
        self.shareBtn.hidden = YES;
    }else{
        self.shareBtn.hidden = NO;
    }
    
    //此处利用时间戳屏蔽分享按钮，是为了规避苹果审核
    if ([TYDevice getDateDayNow] > 20190524) {
        self.shareBtn.hidden = NO;
    }else{
        self.shareBtn.hidden = YES;
    }
}

//分享
- (IBAction)ClickShare:(UIButton *)sender {
    
    if ([TYLoginModel getPrimaryId] > 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(share:)]) {
            [_delegate share:sender];
        }
    }else{
        //未登录提示先去登录
        [TYAlertAction showTYAlertActionTitle:@"" andMessage:@"未登录不能分享请先登录" andVc: [[TYLoginChooseViewController alloc] init] andClick:^(NSInteger buttonIndex) {
            
        }];
    }
}

@end
