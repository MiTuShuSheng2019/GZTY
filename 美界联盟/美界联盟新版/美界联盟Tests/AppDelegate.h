//
//  AppDelegate.h
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign)NSInteger allowRotate;


@end

