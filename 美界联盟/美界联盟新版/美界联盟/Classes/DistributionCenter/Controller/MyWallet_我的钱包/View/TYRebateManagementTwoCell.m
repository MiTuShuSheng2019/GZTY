//
//  TYRebateManagementTwoCell.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYRebateManagementTwoCell.h"

@interface TYRebateManagementTwoCell()
//总分红
@property (weak, nonatomic) IBOutlet UILabel *totalDividendLabel;
//总业绩
@property (weak, nonatomic) IBOutlet UILabel *TotalPerformanceLabel;
//我的分红
@property (weak, nonatomic) IBOutlet UILabel *myDividendLabel;
//团队分红
@property (weak, nonatomic) IBOutlet UILabel *teamDividendLabel;
//我的业绩
@property (weak, nonatomic) IBOutlet UILabel *myPerformanceLabel;
//团队业绩
@property (weak, nonatomic) IBOutlet UILabel *teamPerformanceLabel;
@end



@implementation TYRebateManagementTwoCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYRebateManagementTwoCell";
    TYRebateManagementTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYAmountModel *)model{
    _model = model;
    self.totalDividendLabel.text = [NSString stringWithFormat:@"￥%0.2lf",model.g];
    self.TotalPerformanceLabel.text = [NSString stringWithFormat:@"总业绩:￥%0.2lf",model.l];
    self.myDividendLabel.text = [NSString stringWithFormat:@"￥%0.2lf",model.j];
    self.teamDividendLabel.text = [NSString stringWithFormat:@"￥%0.2lf",model.k];
    self.myPerformanceLabel.text = [NSString stringWithFormat:@"￥%0.2lf",model.d];
    self.teamPerformanceLabel.text = [NSString stringWithFormat:@"￥%0.2lf",model.e];
}

#pragma mark -- 我的分红点击事件
- (IBAction)ClickMyDividend:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(ClickMyDividend:)]) {
        [_delegate ClickMyDividend:sender];
    }
}

#pragma mark -- 团队分红点击事件
- (IBAction)ClickTeamDividend:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickTeamDividend:)]) {
        [_delegate ClickTeamDividend:sender];
    }
}
@end
