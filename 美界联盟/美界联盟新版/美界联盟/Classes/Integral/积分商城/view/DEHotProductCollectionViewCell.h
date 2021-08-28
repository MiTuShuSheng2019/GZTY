//
//  TYHotProductCollectionViewCell.h
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEIntegralMallModel.h"

@protocol DEHotProductCollectionViewCellDelegate <NSObject>
//点击分享
-(void)shopping:(UIButton *)btn;
@end

@interface DEHotProductCollectionViewCell : UICollectionViewCell

/** TYHotProductModel */
@property (nonatomic, strong) DEIntegralMallModel *model;
@property (nonatomic, copy) NSString *type;
/** delegate */
@property (nonatomic, weak) id <DEHotProductCollectionViewCellDelegate> delegate;

@end
