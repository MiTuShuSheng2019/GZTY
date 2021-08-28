//
//  ShowMessage.h
//  TSKDeam
//
//  Created by 赵朋旭 on 15/8/10.
//  Copyright (c) 2015年 赵朋旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IOS6                 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
#define WIDTH         [UIScreen mainScreen].bounds.size.width
#define HEIGHT        [UIScreen mainScreen].bounds.size.height
@interface ShowMessage : NSObject

+(void)showMessage:(NSString*)message;

@end
