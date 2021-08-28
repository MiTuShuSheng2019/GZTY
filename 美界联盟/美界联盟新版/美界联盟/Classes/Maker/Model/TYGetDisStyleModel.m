//
//  TYGetDisStyleModel.m
//  美界联盟
//
//  Created by LY on 2017/11/20.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYGetDisStyleModel.h"

@implementation TYGetDisStyleModel

-(CGFloat)cellH{
    if (!_cellH) {
        
        NSString *str = [NSString stringWithFormat:@"%@%@", PhotoUrl,self.df];
        //获取网络图片的尺寸
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        UIImage *image = [UIImage imageWithData:data];
        
        // 计算文字的高度
//        CGSize rec = [[NSString stringWithFormat:@"地址：%@",self.de] boundingRectWithSize:CGSizeMake(KScreenWidth - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]} context:nil].size;
        
//        _cellBottomViewH = 40 + rec.height + 10;
        
        _cellBottomViewH = 25 + 5;
        //防止图片路径不对的时  默认图片高度120
        if (image.size.width == 0) {
            _cellH = 120 + _cellBottomViewH;
        }else{
            _cellH = image.size.height * KScreenWidth/image.size.width + _cellBottomViewH;
        }
        
    }
    return _cellH;
}
@end
