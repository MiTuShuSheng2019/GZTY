//
//  TYProductDetailsViewController.h
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"
#import "DEIntegralMallModel.h"

@interface DEProductDetailsViewController : TYBaseViewController

/** 进入页面传此模型 DEIntegralMallModel */
@property (nonatomic, strong) DEIntegralMallModel *IModel;
@property (nonatomic, copy) NSString *type;

@end
