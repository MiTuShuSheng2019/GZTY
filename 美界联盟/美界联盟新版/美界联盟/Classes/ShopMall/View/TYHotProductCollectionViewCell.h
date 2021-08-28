//
//  TYHotProductCollectionViewCell.h
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYHotProductModel.h"

@protocol TYHotProductCollectionViewCellDelegate <NSObject>
//点击分享
-(void)share:(UIButton *)btn;
@end

@interface TYHotProductCollectionViewCell : UICollectionViewCell

/** TYHotProductModel */
@property (nonatomic, strong) TYHotProductModel *model;
/** delegate */
@property (nonatomic, weak) id <TYHotProductCollectionViewCellDelegate> delegate;

@end
