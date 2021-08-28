//
//  TYAddressManagementMdoel.m
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYAddressManagementMdoel.h"

@implementation TYAddressManagementMdoel

-(CGFloat)cellH{
    if (!_cellH) {
        
        CGFloat CellMargin = 10;//间距
        CGFloat TopMarginH = 50;//内容上部的高度
        CGFloat bottomMarginH = 50;//内容低部的高度
        CGSize maxSize = CGSizeMake(KScreenWidth - 2 * CellMargin, MAXFLOAT);
        
        CGFloat textH = [self.dg boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        _cellH = textH + TopMarginH + bottomMarginH + CellMargin;
        
    }
    return _cellH;
}

@end
