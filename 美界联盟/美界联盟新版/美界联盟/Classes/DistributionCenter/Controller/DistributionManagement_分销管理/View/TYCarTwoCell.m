//
//  TYCarTwoCell.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYCarTwoCell.h"

@interface TYCarTwoCell()
@property (weak, nonatomic) IBOutlet UIImageView *carImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end

@implementation TYCarTwoCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYCarTwoCell";
    TYCarTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carImgView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(TYCarResultModel *)model{
    _model = model;
     [self.carImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl, model.df]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.contentLab.text = model.de;
    self.moneyLab.text = model.dd;
}

@end
