//
//  TYTeamManagementCell.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYTeamManagementCell.h"

@interface TYTeamManagementCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@end

@implementation TYTeamManagementCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYTeamManagementCell";
    TYTeamManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYTeamManagementModel *)model{
    _model = model;
    self.nameLabel.text = model.fc;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人", model.fb];
}

@end
