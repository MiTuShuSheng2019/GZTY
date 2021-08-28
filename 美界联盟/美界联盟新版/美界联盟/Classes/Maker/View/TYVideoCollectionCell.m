//
//  TYVideoCollectionCell.m
//  美界联盟
//
//  Created by LY on 2017/11/20.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYVideoCollectionCell.h"

@implementation TYVideoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.videoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.videoImageView.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
