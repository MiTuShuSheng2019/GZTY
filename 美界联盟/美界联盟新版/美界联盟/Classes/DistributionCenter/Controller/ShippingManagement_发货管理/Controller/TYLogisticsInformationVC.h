//
//  TYLogisticsInformationVC.h
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYLogisticsInformationVC : TYBaseViewController

//物流名称--必传
@property (nonatomic,strong) NSString *logisticsName;
//物流单号--必传
@property (nonatomic,strong) NSString *sheetCode;

@end
