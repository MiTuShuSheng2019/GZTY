//
//  TYNewShippingAddressVC.h
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"
#import "TYAddressManagementMdoel.h"

@interface TYNewShippingAddressVC : TYBaseViewController

/** type=1 表示编辑 type=2 表示新增地址 */
@property (nonatomic, assign) NSInteger type;

/** 如果是编辑接收此模型 */
@property (nonatomic, strong) TYAddressManagementMdoel *model;

@end
