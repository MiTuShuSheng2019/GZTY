//
//  UIButton+TYButton.h
//  美界APP
//
//  Created by TY-DENG on 17/8/3.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TYButton)
@property (nonatomic,assign) NSInteger key;
//给button添加角标
-(void) addButtonCornerLabelColor:(UIColor *)color string:(NSString *)message;
@end
