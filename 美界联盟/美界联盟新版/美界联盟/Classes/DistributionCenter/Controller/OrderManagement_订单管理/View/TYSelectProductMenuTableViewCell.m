//
//  TYSelectProductMenuTableViewCell.m
//  美界APP
//
//  Created by TY-DENG on 17/8/8.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYSelectProductMenuTableViewCell.h"

@implementation TYSelectProductMenuTableViewCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYSelectProductMenuTableViewCell";
    TYSelectProductMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

-(void)setModel:(TYProdtypeModel *)model{
    _model = model;
    self.menuTitleLabel.text = model.fb;
}

@end
