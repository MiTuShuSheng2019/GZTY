//
//  DEIntegralHeadView.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/29.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import "DEIntegralHeadView.h"

@interface DEIntegralHeadView ()

@end

@implementation DEIntegralHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=RGB(238, 238, 238);
        for (int i=0; i<5; i++) {
            UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            label.font=[UIFont systemFontOfSize:14.];
            label.hidden=YES;
            label.tag = 100+i;
            label.textAlignment=NSTextAlignmentCenter;
            [self addSubview:label];
        }
    }
    return self;
}

-(void)setArray:(NSArray *)array
{
    CGFloat width = SCREEN_WIDTH/array.count;
    for (int i=0; i<array.count; i++) {
        UILabel* label=(UILabel*)[self viewWithTag:100+i];
        label.hidden=NO;
        label.text=array[i];
        label.frame=CGRectMake( width*i, 15, width, 16);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
