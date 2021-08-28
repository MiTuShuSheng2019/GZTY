//
//  TYAwaitingOneCell.m
//  美界app
//
//  Created by LY on 2017/10/20.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYAwaitingOneCell.h"
#import "TYAwaitingSubModel.h"
#import "TYConsumerAwaitingModel.h"
#import "TYMyOrderSubModel.h"

@interface TYAwaitingOneCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shopImagView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//总计
@property (weak, nonatomic) IBOutlet UILabel *totleLabel;

@property (weak, nonatomic) IBOutlet UIView *OnePhotoView;

@property (weak, nonatomic) IBOutlet UIView *MorePhotoView;
@property (weak, nonatomic) IBOutlet UIImageView *moreOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moreTwoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moreThreeImagelView;
@property (weak, nonatomic) IBOutlet UIImageView *moreFourImageView;

@end

@implementation TYAwaitingOneCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYAwaitingOneCell";
    TYAwaitingOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.LookDetailBtn.layer.borderColor = RGB(236, 236, 236).CGColor;
    self.logisticBtn.layer.borderColor = RGB(236, 236, 236).CGColor;
    self.detalBtn.layer.borderColor = RGB(236, 236, 236).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYConsumerAwaitingBigModel *)model{
    _model = model;
    self.timeLabel.text = model.dl;
    if (model.de.count == 1) {
        self.OnePhotoView.hidden = NO;
        self.MorePhotoView.hidden = YES;
        TYConsumerAwaitingModel *subModel = [model.de firstObject];
        self.shopNameLabel.text = subModel.deg;
        [self.shopImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.def]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", subModel.deh];
    }else{
        self.OnePhotoView.hidden = YES;
        self.MorePhotoView.hidden = NO;
        
        TYConsumerAwaitingModel *subModel = [model.de firstObject];
        [self.moreOneImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.def]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        
        
        for (int i = 1; i < model.de.count; ++i) {
            
            if (i == 1) {
                TYConsumerAwaitingModel *subModel = model.de[i];
                [self.moreTwoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.def]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
                
                self.moreThreeImagelView.image = nil;
                self.moreFourImageView.image = nil;
            }else if (i == 2){
                TYConsumerAwaitingModel *subModel = model.de[i];
                [self.moreThreeImagelView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.def]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
                
                self.moreFourImageView.image = nil;
            }else if (i == 3){
                TYConsumerAwaitingModel *subModel = model.de[i];
                [self.moreFourImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.def]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
                
            }else{
                self.moreFourImageView.image = [UIImage imageNamed:@"go_to"];
            }
        }
        
    }
    self.totleLabel.text = [NSString stringWithFormat:@"共%ld件商品，共计￥%0.1lf",model.dh,model.dd];
}


-(void)setMyOrderModel:(TYMyOrderModel *)MyOrderModel{
    _MyOrderModel = MyOrderModel;
    self.timeLabel.text = MyOrderModel.ee;
    
    if (MyOrderModel.ek.count == 1) {
        self.OnePhotoView.hidden = NO;
        self.MorePhotoView.hidden = YES;
        
        TYMyOrderSubModel *subModel = [MyOrderModel.ek firstObject];
      
        if (MyOrderModel.OrderSource == 2) {
            if (subModel.IntergralType == 1) {
                self.priceLabel.text = [NSString stringWithFormat:@"银币 %ld", subModel.Intergral];
            } else {
                self.priceLabel.text = [NSString stringWithFormat:@"金币 %ld", subModel.Intergral];
            }
            self.shopNameLabel.text = subModel.smmjProductName;
            [self.shopImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.smmjProductUrl]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        } else {
            self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", subModel.eke];
            self.shopNameLabel.text = subModel.ekc;
            [self.shopImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.ekb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        }
//        self.shopNameLabel.text = subModel.ekc;
//        [self.shopImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.ekb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
//        self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", subModel.eke];
    }else{
        self.OnePhotoView.hidden = YES;
        self.MorePhotoView.hidden = NO;
        
        TYMyOrderSubModel *subModel = [MyOrderModel.ek firstObject];
        [self.moreOneImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.ekb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        
        
        for (int i = 1; i < MyOrderModel.ek.count; ++i) {
            
            if (i == 1) {
                TYMyOrderSubModel *subModel = MyOrderModel.ek[i];
                [self.moreTwoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.ekb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
                
                self.moreThreeImagelView.image = nil;
                self.moreFourImageView.image = nil;
            }else if (i == 2){
                TYMyOrderSubModel *subModel = MyOrderModel.ek[i];
                [self.moreThreeImagelView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.ekb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
                
                self.moreFourImageView.image = nil;
            }else if (i == 3){
                TYMyOrderSubModel *subModel = MyOrderModel.ek[i];
                [self.moreFourImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,subModel.ekb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
                
            }else{
                self.moreFourImageView.image = [UIImage imageNamed:@"go_to"];
            }
        }
        
    }
    self.stateLabel.text = [NSString stringWithFormat:@"状态:%@",MyOrderModel.ef];
    
    if (MyOrderModel.OrderSource == 2) {
        TYMyOrderSubModel *subModel = [MyOrderModel.ek firstObject];
        if (subModel.IntergralType == 1) {
            self.totleLabel.text = [NSString stringWithFormat:@"共%ld件商品，共计银币%ld",MyOrderModel.ed,subModel.Intergral];
        } else {
            self.totleLabel.text = [NSString stringWithFormat:@"共%ld件商品，共计金币%ld",MyOrderModel.ed,subModel.Intergral];
        }
    } else {
        self.totleLabel.text = [NSString stringWithFormat:@"共%ld件商品，共计￥%@",MyOrderModel.ed,MyOrderModel.ec];
    }
    
//    self.totleLabel.text = [NSString stringWithFormat:@"共%ld件商品，共计￥%@",MyOrderModel.ed,MyOrderModel.ec];
}

#pragma mark -- 查看详情
- (IBAction)LookDetail:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(FirstLookDetail:)]) {
        [_delegate FirstLookDetail:self.logisticBtn];
    }
}


#pragma mark -- 查看物流
- (IBAction)ClickLookLogistic {
    
    if (_delegate && [_delegate respondsToSelector:@selector(LookLogistic:)]) {
        [_delegate LookLogistic:self.logisticBtn];
    }
}

#pragma mark -- 查看详情 或确认收货
- (IBAction)ClickLookDetail {
    if (_delegate && [_delegate respondsToSelector:@selector(LookDetail:)]) {
        [_delegate LookDetail:self.detalBtn];
    }
}

@end
