//
//  TYAlertAction.h
//  美界联盟
//
//  Created by LY on 2017/12/15.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompleteBlock) (NSInteger buttonIndex);

@interface TYAlertAction : NSObject

/** 如果VC不为空点击确定push到对应的VC中 vc为nil然后执行相应的操作  block = 0（点击取消）block = 1（点击确定）*/
+(void)showTYAlertActionTitle:(NSString *)title andMessage:(NSString *)message andVc:(id)vc andClick:(CompleteBlock)block;



@end
