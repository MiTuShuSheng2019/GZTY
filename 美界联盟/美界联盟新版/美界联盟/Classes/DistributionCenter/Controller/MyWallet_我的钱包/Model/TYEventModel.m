//
//  TYEventModel.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYEventModel.h"

@implementation TYEventModel

-(CGFloat)cellH{
    if (!_cellH) {
        
        NSString *str = [NSString stringWithFormat:@"%@%@", PhotoUrl,self.df];
        //获取网络图片的尺寸
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        UIImage *image = [UIImage imageWithData:data];
        CGFloat imageH = image.size.height * (KScreenWidth - 20)/image.size.width;
        
        //防止图片路径不对的时  默认图片高度120
        if (image.size.width == 0) {
            imageH = 120;
            _cellH = 30 + imageH + 85 + 5;
        }else{
            _cellH = 30 + imageH + 85 + 5;
        }
    }
    return _cellH;
}

@end
