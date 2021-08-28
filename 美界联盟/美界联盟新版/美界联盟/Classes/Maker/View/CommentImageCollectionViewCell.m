//
//  CommentImageCollectionViewCell.m
//  MKJWechat
//
//  Created by MKJING on 16/11/25.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "CommentImageCollectionViewCell.h"

@implementation CommentImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.mainImageView.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
