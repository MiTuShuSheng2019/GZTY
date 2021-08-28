//
//  TYChangePasswordViewController.h
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYChangePasswordViewController : TYBaseViewController

/** type=1表示登录密码修改 type=2 交易密码 */
@property (nonatomic, assign) NSInteger type;

@end
