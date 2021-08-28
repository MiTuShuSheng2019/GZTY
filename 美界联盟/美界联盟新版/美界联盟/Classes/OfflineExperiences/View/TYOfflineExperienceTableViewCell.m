//
//  TYOfflineExperienceTableViewCell.m
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYOfflineExperienceTableViewCell.h"

@interface TYOfflineExperienceTableViewCell ()
//商品封面图
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
//名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
//星级评分
@property (weak, nonatomic) IBOutlet TYcommentGradeView *starView;
//体验人数
@property (weak, nonatomic) IBOutlet UILabel *peopleNumberLabel;

@end

@implementation TYOfflineExperienceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.shopImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.shopImageView.clipsToBounds = YES;
    
    self.autoresizingMask = UIViewAutoresizingNone;
    self.starView.userInteractionEnabled = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYOfflineExperienceTableViewCell";
    TYOfflineExperienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setModel:(TYExpCenterModel *)model{
    _model = model;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.ec]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = [TYValidate IsNotNull:model.eb];
     self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[TYValidate IsNotNull:model.ef],[TYValidate IsNotNull:model.eg],[TYValidate IsNotNull:model.eh],[TYValidate IsNotNull:model.ei]];
    self.distanceLabel.text =[NSString stringWithFormat:@"%@km",model.eo];
    self.peopleNumberLabel.text = [NSString stringWithFormat:@"%ld人体验",(long)model.el];
    self.peopleNumberLabel.hidden = YES;//客户需求暂时隐藏
    
    [self.starView setNumberOfStars:5 rateStyle:RateStyleHalfStar isAnination:YES finish:^(CGFloat currentScore) {
    }];
    [self.starView setCurrentScore:model.em];
}



@end
