//
//  TYSelectProductTableViewCell.m
//  美界APP
//
//  Created by TY-DENG on 17/8/7.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYSelectProductTableViewCell.h"


#define DF_KeyPath @"text"

@interface TYSelectProductTableViewCell()<PPNumberButtonDelegate>{
    CGRect cellMoreOldFrame;
    BOOL isReduceButtonHidden;
}
@end

@implementation TYSelectProductTableViewCell

+(instancetype)CellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *ID = @"TYSelectProductTableViewCell";
//    TYSelectProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    TYSelectProductTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

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
    
    self.shopNumberBtn.decreaseTitle = @"-";
    self.shopNumberBtn.increaseTitle = @"+";
    // 设置最小值
    self.shopNumberBtn.minValue = 0;
    // 设置最大值
    self.shopNumberBtn.maxValue = 9999;
    self.shopNumberBtn.editing = NO;
    self.shopNumberBtn.delegate = self;
    self.shopNumberBtn.buttonTitleFont = 17;
}


-(void)setModel:(TYSelectProduct *)model{
    _model = model;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.eb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = model.ec;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.ee];
    self.shopNumberBtn.currentNumber = model.countNumber;
}

#pragma mark -- <PPNumberButtonDelegate>
//@param numberButton 按钮
//@param number 结果
//@param increaseStatus 是否为加状态
- (void)pp_numberButton:(__kindof UIView *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus{
    
    _model.countNumber = number;
//    NSLog(@"%@%ld%d",numberButton, number, increaseStatus);
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectProductTableViewCell: Number: increaseStatus:)]) {
        [_delegate selectProductTableViewCell:self Number:number increaseStatus:increaseStatus];
    }
    
}



@end
