//
//  TYProductDetailsHeadView.h
//  美界联盟
//
//  Created by LY on 2017/10/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYHotProductModel.h"
#import "DEIntegralMallModel.h"

@interface TYProductDetailsHeadView : UIView

//创建方法
+(instancetype)CreatTYProductDetailsHeadView;

/**  TYHotProductModel */
@property (nonatomic, strong) TYHotProductModel *model;

-(void)setIModel:(DEIntegralMallModel *)IModel type:(NSInteger)type;

//轮播图的背景View
@property (weak, nonatomic) IBOutlet UIView *PhotoView;

@end
