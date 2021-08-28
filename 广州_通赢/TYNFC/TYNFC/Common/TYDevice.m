//
//  TYDevice.m
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDevice.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation TYDevice

#pragma mark 获取应用唯一标识
+(NSString *)getAPPID{
    NSString *uuId = [[NSUserDefaults standardUserDefaults] objectForKey:@"fsds876duuId"];
    if (!uuId && uuId.length < 4){
        uuId =[[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuId forKey:@"fsds876duuId"];
    }
    return uuId;
}

//获取版本号
+ (int)systemVersion{
    return [[[[UIDevice currentDevice] systemVersion] substringToIndex:2] floatValue];
}

// ------获取当前设备的IP地址
+(NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

@end
