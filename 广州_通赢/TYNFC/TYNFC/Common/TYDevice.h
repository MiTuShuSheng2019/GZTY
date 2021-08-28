//
//  TYDevice.h
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDevice : NSObject

//获取应用唯一标识
+(NSString *)getAPPID;

//获取手机系统版本号
+ (int)systemVersion;

//获取当前设备的IP地址
+(NSString *)getIPAddress;

@end
