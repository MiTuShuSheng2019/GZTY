//
//  TYConfirmOrderVC.h
//  美界联盟
//
//  Created by LY on 2017/11/28.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYConfirmOrderVC : TYBaseViewController

@property( nonatomic,assign) BOOL isIntergral;

@property( nonatomic,copy) NSString* type;

/*
 * buyType
 * 套餐 传2，
 * 不是套餐传1或者不传
 */
@property( nonatomic,assign) NSInteger buyType;

@end
