//
//  TYReservationCell.m
//  美界联盟
//
//  Created by LY on 2017/11/29.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYReservationCell.h"

@interface TYReservationCell ()
//封面图
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
//名称
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//预约人
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
//日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//预约状态
@property (weak, nonatomic) IBOutlet UILabel *bookeStatusLabel;
//评论状态
@property (weak, nonatomic) IBOutlet UILabel *reviewStatusLabel;
//详情按钮
@property (weak, nonatomic) IBOutlet UIButton *DetailsBtn;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *line;
@end


@implementation TYReservationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.shopImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.shopImageView.clipsToBounds = YES;
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYReservationCell";
    TYReservationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setModel:(TYExpOrderListModel *)model{
    _model = model;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.em]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.shopNameLabel.text = [TYValidate IsNotNull:model.ed];
    self.addressLabel.text = [TYValidate IsNotNull:model.ef];
    
    self.nameLabel.text = [NSString stringWithFormat:@"预约人：%@",[TYValidate IsNotNull:model.ec]];
    self.telLabel.text = [NSString stringWithFormat:@"手机号：%@",[TYValidate IsNotNull:model.eb]];
    self.dateLabel.text = [NSString stringWithFormat:@"预约日期：%@",[TYValidate IsNotNull:model.eg]];
    
    if (model.el == 1) {//预约单状态 状态：1：待接受，2：已接受，3：已体验，9：已取消
        self.bookeStatusLabel.text = @"待接受";
    }else if (model.el == 2){
        self.bookeStatusLabel.text = @"已接受";
    }else if (model.el == 3){
        self.bookeStatusLabel.text = @"已体验";
    }else{
        self.bookeStatusLabel.text = @"已取消";
    }
    
    //    if (model.ek == 1) {//评论的状态1：未审核；2：审核失败；3：审核通过 4：禁用
    //        self.reviewStatusLabel.text = @"未审核";
    //    }else if (model.el == 2){
    //        self.reviewStatusLabel.text = @"审核失败";
    //    }else if (model.el == 3){
    //        self.reviewStatusLabel.text = @"审核通过";
    //    }else{
    //        self.reviewStatusLabel.text = @"禁用";
    //    }
    
    if (model.ek == 3) {//评论的状态1：未审核；2：审核失败；3：审核通过 4：禁用
        self.reviewStatusLabel.text = @"已评论";
    }else{
        self.reviewStatusLabel.text = @"未评论";
    }
}

-(void)setDetailModel:(TYExpOrderListModel *)detailModel{
    _detailModel = detailModel;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,detailModel.em]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.shopNameLabel.text = [TYValidate IsNotNull:detailModel.ed];
    self.addressLabel.text = [TYValidate IsNotNull:detailModel.ef];
    
    self.nameLabel.text = [NSString stringWithFormat:@"预约日期：%@",[TYValidate IsNotNull:detailModel.eg]];
    self.telLabel.text = [NSString stringWithFormat:@"预约人数：%ld", detailModel.eh];
    self.dateLabel.text = [NSString stringWithFormat:@"服务名称：%@",[TYValidate IsNotNull:detailModel.ei]];
    if (detailModel.el == 1) {//预约单状态 状态：1：待接受，2：已接受，3：已体验，9：已取消
        self.bookeStatusLabel.text = @"待接受";
    }else if (detailModel.el == 2){
        self.bookeStatusLabel.text = @"已接受";
    }else if (detailModel.el == 3){
        self.bookeStatusLabel.text = @"已体验";
    }else{
        self.bookeStatusLabel.text = @"已取消";
    }
    self.reviewLabel.text = @"预约备注：";
    self.reviewStatusLabel.textColor = [UIColor darkGrayColor];
    self.reviewStatusLabel.text = [TYValidate IsNotNull:detailModel.eq];
    self.DetailsBtn.hidden = YES;
    self.bottomView.hidden = YES;
    self.line.hidden = YES;
}


//查看详情
- (IBAction)lookDetails:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClicklookDetails:)]) {
        [_delegate ClicklookDetails:sender];
    }
}

//导航
- (IBAction)navigation:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickNavigation:)]) {
        [_delegate ClickNavigation:sender];
    }
}

//电话
- (IBAction)phone:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickPhone:)]) {
        [_delegate ClickPhone:sender];
    }
}

//评论
- (IBAction)comment:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClickComment:)]) {
        [_delegate ClickComment:sender];
    }
}

@end
