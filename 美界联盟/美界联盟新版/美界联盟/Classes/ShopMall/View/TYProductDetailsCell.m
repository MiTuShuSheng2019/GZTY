//
//  TYProductDetailsCell.m
//  美界联盟
//
//  Created by LY on 2017/10/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYProductDetailsCell.h"

@interface TYProductDetailsCell ()

//详情图片
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end


@implementation TYProductDetailsCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYProductDetailsCell";
    TYProductDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(TYDetailsModel *)model{
    _model = model;
//    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",PhotoUrl,model.ea, kAliPicStr_300_300]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    NSString *imgUlr = [NSString stringWithFormat:@"%@%@",PhotoUrl,model.ea];
    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:aliPic(imgUlr, kAliPicStr_150_150)] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
}

@end
