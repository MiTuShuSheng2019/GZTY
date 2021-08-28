//
//  TYCarOneCell.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYCarOneCell.h"

@interface TYCarOneCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end


@implementation TYCarOneCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYCarOneCell";
    TYCarOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    self.contentLab.text = model.count;
    self.moneyLab.text = model.Summoney;
}

@end
