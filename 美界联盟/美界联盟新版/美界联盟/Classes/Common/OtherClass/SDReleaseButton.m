//
//  SDReleaseButton.m
//  BangBang
//
//  Created by LY on 2016/12/1.
//  Copyright © 2016年 Banglin. All rights reserved.
//

#import "SDReleaseButton.h"

@implementation SDReleaseButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.frame.size.width;
    self.imageView.height = self.imageView.frame.size.width;
    
    // 调整文字
    self.titleLabel.x = -((self.frame.size.width * 0.5)/2);
    self.titleLabel.y = self.imageView.frame.size.height + 5;
    
    self.titleLabel.width = self.frame.size.width + (self.frame.size.width * 0.5);
    self.titleLabel.height = self.frame.size.height - self.titleLabel.y;
   
}
@end
