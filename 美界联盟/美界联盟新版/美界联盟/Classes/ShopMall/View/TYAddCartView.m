//
//  TYAddCartView.m
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYAddCartView.h"

@interface TYAddCartView()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopPrice;


@end

@implementation TYAddCartView

+(instancetype)CreatTYAddCartView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    //设置自动伸缩属性为None 让控件正常显示
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.4];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTap)];
    [self addGestureRecognizer:tap];
}

-(void)ClickTap{
    [self removeFromSuperview];
    [self endEditing:YES];
}
//关闭
- (IBAction)ClickClose {
    [self removeFromSuperview];
}

#pragma mark -- 加入购物车
- (IBAction)ClickConfirm {
    if (_delegate && [_delegate respondsToSelector:@selector(addCar)]) {
        [_delegate addCar];
    }
}

-(void)setModel:(TYHotProductModel *)model{
    _model = model;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoUrl,model.ee]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.shopName.text = model.eb;
    if (model.ed.length == 0) {
        self.shopPrice.text = [NSString stringWithFormat:@"￥0.00"];
    }else{
        self.shopPrice.text = [NSString stringWithFormat:@"￥%@", model.ec];
    }
    
}

@end
