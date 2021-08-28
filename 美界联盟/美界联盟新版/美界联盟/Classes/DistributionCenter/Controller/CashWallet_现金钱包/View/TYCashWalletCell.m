//
//  TYCashWalletCell.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYCashWalletCell.h"

@interface TYCashWalletCell ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;


@end

@implementation TYCashWalletCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYCashWalletCell";
    TYCashWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moneyLab.font = [UIFont boldSystemFontOfSize:22];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(TYCashModel *)model{
    _model = model;
    self.moneyLab.text = [NSString stringWithFormat:@"￥%@", model.SurplusAmount];
}

- (IBAction)ClickTheButton:(UIButton *)sender {
    //1提现2明细
    if (_clickTheButtonBlock) {
        _clickTheButtonBlock(sender.tag);
    }
}

@end
