//
//  TYDistributorsCell.m
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDistributorsCell.h"

@interface TYDistributorsCell()
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
//等级
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end


@implementation TYDistributorsCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYDistributorsCell";
    TYDistributorsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.shopImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.shopImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.shopImageView.clipsToBounds = YES;
//    //适应retina屏幕
//    [self.shopImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYDistributorsModel *)model{
    _model = model;
    //给头部的控件赋值
    [self.shopImageView setHead:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.ee]];
    
    self.gradeLabel.text = [NSString stringWithFormat:@"姓名：%@", [TYValidate IsNotNull:model.eb]];
    self.nameLabel.text = [NSString stringWithFormat:@"电话：%@", [TYValidate IsNotNull:model.ed]];
    self.telLabel.text = [NSString stringWithFormat:@"等级：%@",[TYValidate IsNotNull:model.ef]];
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@", [TYValidate IsNotNull:model.eh]];
}

@end
