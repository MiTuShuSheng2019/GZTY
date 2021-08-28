//
//  TYResultsCell.m
//  美界联盟
//
//  Created by LY on 2018/9/14.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import "TYResultsCell.h"

@interface TYResultsCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UILabel *numberLab;


@end

@implementation TYResultsCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYResultsCell";
    TYResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.headImgView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYTeamOrderCount *)model{
    _model = model;
     [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getPhoto]]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.numberLab.text = [NSString stringWithFormat:@"订单总数：%ld  订单总额：%0.2lf", model.e, model.d];
}

@end
