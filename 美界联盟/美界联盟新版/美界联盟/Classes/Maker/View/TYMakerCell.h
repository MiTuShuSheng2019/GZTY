//
//  TYMakerCell.h
//  美界联盟
//
//  Created by LY on 2017/11/13.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYMakerCell : UICollectionViewCell
//图标
@property (weak, nonatomic) IBOutlet UIImageView *icon;
//标题
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
