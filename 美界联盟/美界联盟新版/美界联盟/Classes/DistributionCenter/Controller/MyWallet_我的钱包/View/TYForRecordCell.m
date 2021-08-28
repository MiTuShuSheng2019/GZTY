//
//  TYForRecordCell.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYForRecordCell.h"

@interface TYForRecordCell()
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//汽车封面图
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
//名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//审核状态
@property (weak, nonatomic) IBOutlet UILabel *auditLabel;

@end

@implementation TYForRecordCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYForRecordCell";
    TYForRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carImageView.contentMode = UIViewContentModeScaleAspectFill;    self.carImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;    self.carImageView.clipsToBounds = YES;
    //适应retina屏幕
    [self.carImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYForRecord *)model{
    _model = model;
    self.timeLabel.text = [NSString stringWithFormat:@"兑换时间：%@",model.de];
     [self.carImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.da]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = [NSString stringWithFormat:@"奖品：%@",model.dc];
    
    //1总部待审核，2：总部审核，3已首付提车，4已全款提车
    if (model.df == 1) {
        self.auditLabel.text = @"总部待审核";
    }else if (model.df == 2){
        self.auditLabel.text = @"总部审核";
    }else if (model.df == 3){
        self.auditLabel.text = @"已首付提车";
    }else{
        self.auditLabel.text = @"已全款提车";
    }
}
@end
