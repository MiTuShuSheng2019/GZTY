//
//  DESelectPackageTableViewCell.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/10/30.
//  Copyright © 2019 刘燚. All rights reserved.
//

#import "DESelectPackageTableViewCell.h"

@implementation DESelectPackageTableViewCell

+(instancetype)CellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *ID = @"DESelectPackageTableViewCell";
//    DESelectPackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    DESelectPackageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.productImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.productImageView.clipsToBounds = YES;
    self.productImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

-(void)setModel:(TYSelectProduct *)model{
    _model = model;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.eb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = model.ec;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.ee];
}

-(IBAction)shoppingBtnClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectPackageTableViewCell:)]) {
        [_delegate selectPackageTableViewCell:self];
    }
}

@end
