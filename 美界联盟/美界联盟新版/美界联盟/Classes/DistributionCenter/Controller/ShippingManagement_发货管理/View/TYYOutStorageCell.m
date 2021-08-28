//
//  TYYOutStorageCell.m
//  美界联盟
//
//  Created by LY on 2017/11/10.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYYOutStorageCell.h"

@interface TYYOutStorageCell ()
//流水号
@property (weak, nonatomic) IBOutlet UILabel *StreamNumberLabel;
//分销商
@property (weak, nonatomic) IBOutlet UILabel *distributorsLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLabel;


@end

@implementation TYYOutStorageCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYYOutStorageCell";
    TYYOutStorageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYOutStorageModel *)model{
    _model = model;
    self.StreamNumberLabel.text = [NSString stringWithFormat:@"流水号：%@",model.eb];
    self.distributorsLabel.text = [NSString stringWithFormat:@"姓名：%@",model.ec];
    self.telLabel.text = [NSString stringWithFormat:@"手机：%@",model.ed];
}

@end
