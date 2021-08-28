//
//  TYContactUsCell.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYContactUsCell.h"

@interface TYContactUsCell()


@end

@implementation TYContactUsCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYContactUsCell";
    TYContactUsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];    if (!cell) {
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

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
