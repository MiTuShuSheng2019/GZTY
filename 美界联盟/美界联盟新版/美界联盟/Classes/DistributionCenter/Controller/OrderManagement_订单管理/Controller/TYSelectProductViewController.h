//
//  TYSelectProductViewController.h
//  美界APP
//
//  Created by TY-DENG on 17/8/7.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYSelectProductViewController : TYBaseViewController
@property (nonatomic,assign)   Boolean isNeedPopViewController;
@property (nonatomic,strong) NSMutableDictionary *productSelectedDictionary; //选择的产品保存在这里
@end
