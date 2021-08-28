//
//  TYCashModel.h
//  美界联盟
//
//  Created by LY on 2018/11/14.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYCashModel : NSObject
/** 账户余额 */
@property (nonatomic, strong) NSString *SurplusAmount;
/** 是否需要跳转微信 */
@property (nonatomic, assign) BOOL hasWx;
/** 跳转微信连接 */
@property (nonatomic, strong) NSString *link;

@end

NS_ASSUME_NONNULL_END
