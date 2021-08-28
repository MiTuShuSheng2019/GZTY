//
//  TYRebateManagementThreeCell.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYRebateManagementThreeCell.h"

@interface TYRebateManagementThreeCell()
//豪车图片
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carImageViewH;

@end

@implementation TYRebateManagementThreeCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYRebateManagementThreeCell";
    TYRebateManagementThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.carImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.carImageView.clipsToBounds = YES;
    //适应retina屏幕
    [self.carImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYEventModel *)model{
    _model = model;
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.df]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
}


@end
