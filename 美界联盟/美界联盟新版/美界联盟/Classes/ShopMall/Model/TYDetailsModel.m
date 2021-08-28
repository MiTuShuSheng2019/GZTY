//
//  TYDetailsModel.m
//  美界联盟
//
//  Created by LY on 2017/11/22.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDetailsModel.h"

@implementation TYDetailsModel

-(CGFloat)cellH{
    if (!_cellH) {
        
        //获取网络图片的尺寸
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,self.ea]]];
        UIImage *image = [UIImage imageWithData:data];
        
        _cellH = image.size.height * KScreenWidth/image.size.width;
        
    }
    return _cellH;
}

@end
