//
//  TYCommentModel.m
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYCommentModel.h"

@implementation TYCommentModel

-(CGFloat)cellH{
    if (!_cellH) {
        CGFloat topH = 65;//顶部高度
        CGFloat bottomH = 130;//低部高度
        CGFloat cellM = 10;//间距
        CGSize rec = [self.ec boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
        if (self.ef.count == 0) {
            _cellH = topH + rec.height + cellM;
        }else{
            _cellH = topH + rec.height + bottomH + cellM;
        }
    }
    return _cellH;
}

@end
