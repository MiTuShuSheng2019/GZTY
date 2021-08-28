//
//  TYLuxuryEventDetail.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLuxuryEventDetail.h"

@implementation TYLuxuryEventDetail

-(CGFloat)ChoosePrizeCellH{
    if (!_ChoosePrizeCellH) {
        
        CGFloat CellMargin = 10;//间距
        CGFloat TopMarginH = 90;//内容上部的高度
        CGSize maxSize = CGSizeMake(KScreenWidth - 2 * CellMargin, MAXFLOAT);
     
        CGFloat textH = [self.dg boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        _ChoosePrizeCellH = textH + TopMarginH + CellMargin;
    }
    return _ChoosePrizeCellH;
}


-(CGFloat)cellH{
    if (!_cellH) {
        
        CGFloat CellMargin = 10;//间距
        CGFloat bottonMarginH = 60;//内容底部的高度
        
        NSString *str = [NSString stringWithFormat:@"%@%@", PhotoUrl,self.dd];
        //获取网络图片的尺寸
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        UIImage *image = [UIImage imageWithData:data];
        //防止图片路径不对的时  默认图片高度120
        if (image.size.width == 0) {
            _cellH = CellMargin + 120 + bottonMarginH;
        }else{
            _cellH = CellMargin + image.size.height * (KScreenWidth - 20)/image.size.width + bottonMarginH;
        }
    }
    return _cellH;
}
@end
