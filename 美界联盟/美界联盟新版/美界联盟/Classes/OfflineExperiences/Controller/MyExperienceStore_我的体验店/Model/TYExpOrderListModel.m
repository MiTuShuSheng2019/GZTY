//
//  TYExpOrderListModel.m
//  美界联盟
//
//  Created by LY on 2017/11/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYExpOrderListModel.h"

@implementation TYExpOrderListModel

-(CGFloat)cellH{
    if (!_cellH) {
       
        CGSize rec = [self.eq boundingRectWithSize:CGSizeMake(KScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
        _cellH = 85 + 110 + rec.height + 10;
        
    }
    return _cellH;
}

@end
