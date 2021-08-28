//
//  UIImage+LYExtension.m
//  BangBang
//
//  Created by LY on 2017/6/21.
//  Copyright © 2017年 Banglin. All rights reserved.
//

#import "UIImage+LYExtension.h"

@implementation UIImage (LYExtension)

- (UIImage *)circleImage
{
    //开启图形上线文 NO代表透明  你可以试试YES YES会出现黑边
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)sizeWith
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(sizeWith/CGRectGetWidth(extent), sizeWith/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
