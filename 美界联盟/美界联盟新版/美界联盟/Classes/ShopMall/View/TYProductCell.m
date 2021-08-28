//
//  TYProductCell.m
//  美界联盟
//
//  Created by LY on 2017/11/22.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYProductCell.h"

@interface TYProductCell ()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//微信号
@property (weak, nonatomic) IBOutlet UILabel *wxLabel;
//二维码
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end

@implementation TYProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
   
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYProductCell";
    TYProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYLoginModel *)model{
    _model = model;
    [self.headImageView setHead:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getPhoto]]];
    self.nameLabel.text = [TYValidate IsNotNull:[TYLoginModel getUserName]];
    self.wxLabel.text = [TYValidate IsNotNull:[TYLoginModel getWeiXing]];
    if ([[TYLoginModel getDistributorQrCode] isEqualToString:@"<null>"]) {
        self.codeImageView.hidden = YES;
    }else{
        self.codeImageView.hidden = NO;
//        [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getDistributorQrCode]]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        NSString *imgUlr = [NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getDistributorQrCode]];
        [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:aliPic(imgUlr, kAliPicStr_150_150)] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    }
    self.wxLabel.hidden = NO;
    
}

-(void)setConsumerModel:(TYConsumerLoginModel *)consumerModel{
    _consumerModel = consumerModel;
    [self.headImageView setHead:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYConsumerLoginModel getPhoto]]];
    self.nameLabel.text = [TYValidate IsNotNull:[TYConsumerLoginModel getUserName]];
    self.wxLabel.hidden = YES;
    self.codeImageView.hidden = YES;
  
}
@end
