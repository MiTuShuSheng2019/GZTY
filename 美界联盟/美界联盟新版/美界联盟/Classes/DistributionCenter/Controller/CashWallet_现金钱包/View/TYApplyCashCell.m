//
//  TYApplyCashCell.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYApplyCashCell.h"

@interface TYApplyCashCell ()

@property (weak, nonatomic) IBOutlet UITextField *moneyFid;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;

@end

@implementation TYApplyCashCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYApplyCashCell";
    TYApplyCashCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYCashModel *)model{
    _model = model;
    self.balanceLab.text = [NSString stringWithFormat:@"可用余额%@", model.SurplusAmount];
}

- (IBAction)ClickTheButton:(UIButton *)sender {
    //1全部提现2提现
    if (sender.tag == 1) {
        self.moneyFid.text = [NSString stringWithFormat:@"%@", _model.SurplusAmount];
         return;
    }else{
        if ([self.moneyFid.text doubleValue] <= 0) {
            [TYShowHud showHudErrorWithStatus:@"请输入提现金额"];
            return;
        }
    }
    
    if (_clickTheButtonBlock) {
        _clickTheButtonBlock(self.moneyFid.text);
    }
}

@end
