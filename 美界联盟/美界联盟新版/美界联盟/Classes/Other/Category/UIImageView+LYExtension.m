//
//  UIImageView+LYExtension.m
//  BangBang
//
//  Created by LY on 2017/6/21.
//  Copyright © 2017年 Banglin. All rights reserved.
//

#import "UIImageView+LYExtension.h"
#import "UIImage+LYExtension.h"

@implementation UIImageView (LYExtension)

-(void)setHead:(NSString *)url{
    UIImage *placeholder = [[UIImage imageNamed:@"image_default_loading"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholder;
        //如果你不想要圆形头像直接注释调self.image = image ? [image circleImage] : placeholder;就可以了 统一设置方便你更改需求
    }];
}



@end
