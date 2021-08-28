//
//  TYTeamDetailsCell.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYTeamDetailsCell.h"

@interface TYTeamDetailsCell()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//等级
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
//上级姓名
@property (weak, nonatomic) IBOutlet UILabel *upNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upNameLabelH;

//上级等级
@property (weak, nonatomic) IBOutlet UILabel *upGradeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upGradeLabelH;
//团队人数
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation TYTeamDetailsCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYTeamDetailsCell";
    TYTeamDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //客服需求需隐藏
    self.upGradeLabel.hidden = YES;
    self.numberLabel.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYDistributorsModel *)model{
    _model = model;
   [self.headImageView setHead:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.ee]];
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",model.eb];
    self.gradeLabel.text = [NSString stringWithFormat:@"等级：%@",model.ef];
    
//    self.upNameLabel.text = [NSString stringWithFormat:@"上级姓名：%@",model.ei];
//    self.upGradeLabel.text = [NSString stringWithFormat:@"上级等级：%@",model.ej];
//    self.numberLabel.text = [NSString stringWithFormat:@"团队人数：%ld人",model.ek];
    self.upNameLabel.text = [NSString stringWithFormat:@"团队人数：%ld人",model.ek];
}

@end
