//
//  TYWeChatPayment.h
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYWeChatPaymentDelegate <NSObject>

//成功
-(void)paySucceed:(NSInteger)type;

//失败
-(void)PayFailure:(NSInteger)type;

@end

//微信支付的基类
@interface TYWeChatPayment : NSObject<WXApiDelegate>

+(instancetype)sharedManager;

//调起微信支付
+ (void)jumpToBizPay:(NSDictionary *)dict;

@property (nonatomic, assign) id<TYWeChatPaymentDelegate> delegate;

@end
