//
//  TYLuxuryCarCell.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLuxuryCarCell.h"

@interface TYLuxuryCarCell()
//汽车封面图
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
//名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//继续努力
@property (weak, nonatomic) IBOutlet UILabel *keepTryingLabel;

@end

@implementation TYLuxuryCarCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYLuxuryCarCell";
    TYLuxuryCarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.keepTryingLabel.layer.borderWidth = 1;
    self.keepTryingLabel.layer.borderColor = RGB(222, 222, 222).CGColor;
    
    self.carImageView.contentMode = UIViewContentModeScaleAspectFill;    self.carImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;    self.carImageView.clipsToBounds = YES;
    //适应retina屏幕
    [self.carImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYLuxuryEventDetail *)model{
    _model = model;
    
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.dd]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = [NSString stringWithFormat:@"奖品:%@",model.df];
    self.contentLabel.text = [NSString stringWithFormat:@"季度销售额满%0.1lf万奖励首付",model.de/10000.0];
}

-(void)setDetailModel:(TYLuxuryEventDetail *)DetailModel{
    _DetailModel = DetailModel;
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,DetailModel.dd]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",DetailModel.df];
    self.contentLabel.text = [NSString stringWithFormat:@"%0.1lf万元",DetailModel.dc/10000.0];
    self.contentLabel.textColor = [UIColor redColor];
    self.keepTryingLabel.hidden = YES;
}

@end
