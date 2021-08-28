//
//  TYTeamTwoCell.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYTeamTwoCell.h"

@interface TYTeamTwoCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;



@end

@implementation TYTeamTwoCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYTeamTwoCell";
    TYTeamTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
   self.headImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(TYResultDetailModel *)model{
    _model = model;
   [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl, model.url]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLab.text = model.name;
    self.phoneLab.text = model.time;
    self.moneyLab.text = model.money;
}


@end
