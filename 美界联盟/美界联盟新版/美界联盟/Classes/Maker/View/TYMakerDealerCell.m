//
//  TYMakerDealerCell.m
//  美界联盟
//
//  Created by LY on 2017/11/18.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMakerDealerCell.h"

@interface TYMakerDealerCell ()


//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//销售量
@property (weak, nonatomic) IBOutlet UILabel *SalesVolumeLabel;
//底部视图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@end

@implementation TYMakerDealerCell

//适应retina屏幕
//[self.shopImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    //客服需求先隐藏
    self.addressLabel.hidden = YES;
    self.SalesVolumeLabel.hidden = YES;
}

-(void)setModel:(TYGetDisStyleModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoUrl,model.df]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = [TYValidate IsNotNull:model.da];
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",[TYValidate IsNotNull:model.de]];
    self.SalesVolumeLabel.text = [NSString stringWithFormat:@"月销量%@",[TYValidate IsNotNull:model.db]];
    
    self.bottomViewH.constant = model.cellBottomViewH;
}

@end
