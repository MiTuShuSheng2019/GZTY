//
//  TYOfflineNearbyHeadView.m
//  美界联盟
//
//  Created by ydlmac2 on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYOfflineNearbyHeadView.h"

@implementation TYOfflineNearbyHeadView

+ (instancetype)showHeadView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        UILabel *near = [[UILabel alloc] init];
        near.backgroundColor = [UIColor whiteColor];
        near.text = @"  附近体验店";
        [self addSubview:near];
        [near makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.bottom.equalTo(-1);
        }];
        
    }
    return self;
}

@end
