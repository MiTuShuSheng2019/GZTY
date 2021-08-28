//
//  TYCargoView.h
//  美界联盟
//
//  Created by LY on 2017/12/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCargoModel.h"

@interface TYCargoView : UIView

+(instancetype)CreatTTYCargoView;

/** TYCargoModel */
@property (nonatomic, strong) TYCargoModel *model;

@end
