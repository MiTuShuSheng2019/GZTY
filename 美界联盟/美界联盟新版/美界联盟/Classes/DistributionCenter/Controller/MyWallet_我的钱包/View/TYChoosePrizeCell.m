//
//  TYChoosePrizeCell.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYChoosePrizeCell.h"

@interface TYChoosePrizeCell()
//规则
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@end

@implementation TYChoosePrizeCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYChoosePrizeCell";
    TYChoosePrizeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYLuxuryEventDetail *)model{
    _model = model;
    self.ruleLabel.text = model.dg;
}

@end
