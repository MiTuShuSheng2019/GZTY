//
//  TYBillDetailCell.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYBillDetailCell.h"

@interface TYBillDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


@end

@implementation TYBillDetailCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYBillDetailCell";
    TYBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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


-(void)setModel:(TYBillDetailModel *)model{
    _model = model;
     self.moneyLab.text = [NSString stringWithFormat:@"￥%.2lf", model.lAmount];
    self.timeLab.text = model.lDate;
    self.contentLab.text = model.lDescribe;
    self.nameLab.text = model.lName;
}

@end
