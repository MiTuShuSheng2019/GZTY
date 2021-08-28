//
//  DEIntegralExchangeController.h
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/24.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface DEIntegralExchangeController : TYBaseViewController

/*
 * userInteractionEnabled
 * YES 积分兑换
 * NO 积分兑换详情
 */
@property (assign, nonatomic) BOOL  myUserInteractionEnabled;

@property (nonatomic, strong) NSDictionary *infoDict;


@end
