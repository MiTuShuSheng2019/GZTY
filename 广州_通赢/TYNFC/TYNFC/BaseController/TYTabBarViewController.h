//
//  TYTabBarViewController.h
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYTabBarViewController : UITabBarController

- (void)upChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage;

@end
