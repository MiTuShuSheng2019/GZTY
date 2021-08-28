//
//  TYCargoView.m
//  美界联盟
//
//  Created by LY on 2017/12/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYCargoView.h"

@interface TYCargoView ()

@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifveLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevenLabel;
@property (weak, nonatomic) IBOutlet UILabel *eighthLabel;
@property (weak, nonatomic) IBOutlet UILabel *nineLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenLabel;

@end

@implementation TYCargoView

+(instancetype)CreatTTYCargoView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
    [self addGestureRecognizer:tap];
}

//点击非弹框区域去取消
-(void)cancelView{
    [self removeFromSuperview];
}

-(void)setModel:(TYCargoModel *)model{
    _model = model;
    self.oneLabel.text = [NSString stringWithFormat:@"条码号:%@",[TYValidate IsNotNull:model.Barcode]];
    self.twoLabel.text = [NSString stringWithFormat:@"条码类型:%@",[TYValidate IsNotNull:model.BarcodeTypeStr]];
    self.threeLabel.text = [NSString stringWithFormat:@"操作类型:%@",[TYValidate IsNotNull:model.DoTypeStr]];
    self.fourLabel.text = [NSString stringWithFormat:@"产品名称:%@",[TYValidate IsNotNull:model.ProductFullName]];
    self.fifveLabel.text = [NSString stringWithFormat:@"收货人:%@",[TYValidate IsNotNull:model.InDistributorFullName]];
    self.sixLabel.text = [NSString stringWithFormat:@"发货人:%@",[TYValidate IsNotNull:model.DistributorFullName]];
    self.sevenLabel.text = [NSString stringWithFormat:@"操作标题:%@",[TYValidate IsNotNull:model.OperateTitle]];
    self.eighthLabel.text = [NSString stringWithFormat:@"操作端:%@",[TYValidate IsNotNull:model.OperateTypeStr]];
    self.nineLabel.text = [NSString stringWithFormat:@"操作时间:%@",[TYValidate IsNotNull:model.CreateTime]];
    self.tenLabel.text = [NSString stringWithFormat:@"操作者:%@",[TYValidate IsNotNull:model.CreatorName]];
}

@end
