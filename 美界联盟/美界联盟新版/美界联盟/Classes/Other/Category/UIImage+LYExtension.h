//
//  UIImage+LYExtension.h
//  BangBang
//
//  Created by LY on 2017/6/21.
//  Copyright © 2017年 Banglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LYExtension)
/**
 * 圆形图片
 */
- (UIImage *)circleImage;


/**
 *  此方法使得生成的二维码更加清晰
 *  根据CIImage生成指定大小的UIImage
 *  @param image CIImage
 *  @param sizeWith  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)sizeWith;

@end
