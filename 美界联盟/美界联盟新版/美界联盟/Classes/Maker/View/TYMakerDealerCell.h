//
//  TYMakerDealerCell.h
//  美界联盟
//
//  Created by LY on 2017/11/18.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYGetDisStyleModel.h"

@interface TYMakerDealerCell : UICollectionViewCell


/** TYGetDisStyleModel */
@property (nonatomic, strong) TYGetDisStyleModel *model;

//图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
