//
//  TYDealerManagementCell.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDealerManagementCell.h"

@interface TYDealerManagementCell()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//头像的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewW;

//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//等级
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
//微信
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@end

@implementation TYDealerManagementCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYDealerManagementCell";
    TYDealerManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYLowerCusModel *)model{
    _model = model;
    [self.headImageView setHead:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.ee]];
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", [TYValidate IsNotNull:model.eb]];
    self.gradeLabel.text = [NSString stringWithFormat:@"等级：%@", [TYValidate IsNotNull:model.ef]];
    self.weixinLabel.text = [NSString stringWithFormat:@"微信：%@",  [TYValidate IsNotNull:model.ec]];
    self.telLabel.text = [NSString stringWithFormat:@"电话：%@", [TYValidate IsNotNull:model.ed]];
   
}

-(void)setApplyModel:(TYReApplyModel *)applyModel{
    _applyModel = applyModel;
    self.headImageView.hidden = YES;
    self.headImageViewW.constant = 0;
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", applyModel.eb];
    self.gradeLabel.text = [NSString stringWithFormat:@"电话：%@", applyModel.ec];
    self.weixinLabel.text = [NSString stringWithFormat:@"原等级：%@", applyModel.ee];
    self.telLabel.text = [NSString stringWithFormat:@"申请等级：%@", applyModel.ed];
    self.isThroughBtn.backgroundColor = [UIColor whiteColor];
    [self.isThroughBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.isThroughBtn setTitle:applyModel.ef forState:UIControlStateNormal];
    
}

- (IBAction)ClickThroughBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickThrough:)]) {
        [_delegate ClickThrough:sender];
    }
}
@end
