//
//  TYShareBonusFoorView.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShareBonusFoorView.h"

@interface TYShareBonusFoorView()


@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@end

@implementation TYShareBonusFoorView

+(instancetype)CreatTYShareBonusFoorView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lookBtn.layer setBorderWidth:1.0];
    [self.lookBtn.layer setBorderColor:RGB(222, 222, 222).CGColor];//边框颜色
}

//产看历史
- (IBAction)SeeProductionHistory:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(ClickSeeProductionHistory)]) {
        [_delegate ClickSeeProductionHistory];
    }
}

@end
