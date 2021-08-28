//
//  TYSchoolCell.m
//  美界联盟
//
//  Created by LY on 2017/11/18.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYSchoolCell.h"
@interface TYSchoolCell ()
//图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TYSchoolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.iconImageView.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYSchoolCell";
    TYSchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
    }
    return cell;
}

-(void)setModel:(TYMakConListModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoUrl,model.dc]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.titleLabel.text = model.de;
    self.contentLabel.text = model.df;
    self.timeLabel.text = model.dj;
}

@end
