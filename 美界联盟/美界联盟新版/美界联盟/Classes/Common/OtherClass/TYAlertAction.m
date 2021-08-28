//
//  TYAlertAction.m
//  美界联盟
//
//  Created by LY on 2017/12/15.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYAlertAction.h"

@implementation TYAlertAction

+(void)showTYAlertActionTitle:(NSString *)title andMessage:(NSString *)message andVc:(id)vc andClick:(CompleteBlock)block{
    
    UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nagVc = [tabVc selectedViewController];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(0);
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([vc isKindOfClass:[UIViewController class]]) {
            [nagVc pushViewController:vc animated:YES];
        }else{
            block(1);
        }
        
    }];
    
    [alert addAction:action];
    [alert addAction:action1];
    [nagVc presentViewController:alert animated:YES completion:nil];
}


@end
