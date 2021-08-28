//
//  TYExpCenterDetailModel.m
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYExpCenterDetailModel.h"

@implementation TYExpCenterDetailModel

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"s":@"TYServiceModel"
             };
}


-(CGFloat)cellH{
    if (!_cellH) {
        CGSize rec = [self.g boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
        _cellH = rec.height + 10;
    }
    return _cellH;
}

@end
