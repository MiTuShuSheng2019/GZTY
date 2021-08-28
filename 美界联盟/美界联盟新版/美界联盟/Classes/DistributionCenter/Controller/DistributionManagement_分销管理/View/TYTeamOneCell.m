//
//  TYTeamOneCell.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYTeamOneCell.h"

@interface TYTeamOneCell()
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *totalRebateLab;


@end



@implementation TYTeamOneCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYTeamOneCell";
    TYTeamOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(TYRebateModel *)model{
    _model = model;
    self.totalMoneyLab.text = model.Summoney;
    self.totalRebateLab.text = model.Permonty;
}

@end
