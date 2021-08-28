//
//  TYDetailsHeadView.m
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDetailsHeadView.h"

@interface TYDetailsHeadView ()


@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet TYcommentGradeView *starView;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumberLabel;

@end


@implementation TYDetailsHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    self.starView.userInteractionEnabled = false;
}


+(instancetype)CreatTYDetailsHeadView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)setModel:(TYExpCenterModel *)model{
    _model = model;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.ec]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = [TYValidate IsNotNull:model.eb];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[TYValidate IsNotNull:model.ef],[TYValidate IsNotNull:model.eh],[TYValidate IsNotNull:model.eg],[TYValidate IsNotNull:model.ei]];
//    self.peopleNumberLabel.text = [NSString stringWithFormat:@"%ld人体验",model.el];
    self.peopleNumberLabel.hidden = YES;
    [self.starView setNumberOfStars:5 rateStyle:RateStyleHalfStar isAnination:YES finish:^(CGFloat currentScore) {
        
    }];
    [self.starView setCurrentScore:model.em];
}

//点击导航
- (IBAction)ClickNavigation {
    if (_delegate && [_delegate respondsToSelector:@selector(Navigation)]) {
        [_delegate Navigation];
    }
}

//点击打电话
- (IBAction)ClickPhone {
    if (_delegate && [_delegate respondsToSelector:@selector(CallPhone)]) {
        [_delegate CallPhone];
    }
}

//点击预约
- (IBAction)ClickMakeAppointment {
    if (_delegate && [_delegate respondsToSelector:@selector(MakeAppointment)]) {
        [_delegate MakeAppointment];
    }
    
}

@end
