//
//  TYHasExperienceCell.m
//  美界联盟
//
//  Created by LY on 2017/11/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYHasExperienceCell.h"

@interface TYHasExperienceCell ()
//预约人
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//预约手机
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//预约人数
@property (weak, nonatomic) IBOutlet UILabel *peopleNumeberLabel;
//服务项目
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
//预约备注
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;





@end

@implementation TYHasExperienceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYHasExperienceCell";
    TYHasExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
    }
    return cell;
}

-(void)setModel:(TYExpOrderListModel *)model{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"预约人：%@", model.ec];
    self.phoneLabel.text = [NSString stringWithFormat:@"预约手机：%@", model.eb];
    self.peopleNumeberLabel.text = [NSString stringWithFormat:@"预约人数：%ld", model.eh];
    self.serviceLabel.text = [NSString stringWithFormat:@"服务项目：%@", model.ei];
    self.remarkLabel.text = [NSString stringWithFormat:@"预约备注：%@", model.eq];
}

@end
