//
//  TYMakerTitleView.m
//  美界联盟
//
//  Created by LY on 2017/11/13.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMakerTitleView.h"

@implementation TYMakerTitleView

+(instancetype)CreatTYMakerTitleView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
