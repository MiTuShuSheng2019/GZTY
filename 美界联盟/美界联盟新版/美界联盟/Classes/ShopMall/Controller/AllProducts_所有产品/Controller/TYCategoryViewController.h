//
//  TYCategoryViewController.h
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@class TYBannerModel;@class TYSMProdTypeModel;
@interface TYCategoryViewController : TYBaseViewController

-(void)setUpMyCollectionView;

//分销商登录传此模型
@property (nonatomic, strong) TYBannerModel *model;

/** 消费者登录传此模型 */
@property (nonatomic, strong) TYSMProdTypeModel *SModel;
@end
