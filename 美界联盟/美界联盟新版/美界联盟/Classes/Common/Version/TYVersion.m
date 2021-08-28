//
//  TYVersion.m
//  美界联盟
//
//  Created by LY on 2017/10/26.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYVersion.h"

@implementation TYVersion

+(void)CheckVersion{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    [manger POST:VersionUpdateRequest parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject == nil) {
            
        }else{
            NSString *newVersion;
            //从数据字典中检出版本号数据
            NSArray *configData = [responseObject valueForKey:@"results"];
            
            [TYSingleton shareSingleton].version = [[configData firstObject] objectForKey:@"version"];
            
            for(id config in configData){
                
                newVersion = [config valueForKey:@"version"];
            }
            
            //获取本地软件的版本号
            NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
            int newVersionNum=0;
            int localVersionNum = 0;
            //对比发现的新版本和本地的版本
            NSArray *newVersionArr = [newVersion componentsSeparatedByString:@"."];
            for (int i=0; i<newVersionArr.count; i++) {
                int newVersion = [newVersionArr[i] intValue];
                newVersionNum = newVersionNum * 10 + newVersion;
            }
            NSArray *localVersionArr = [localVersion componentsSeparatedByString:@"."];
            for (int i=0; i<localVersionArr.count; i++) {
                int localVersion = [localVersionArr[i] intValue];
                localVersionNum = localVersionNum * 10 + localVersion;
            }
            
            if (newVersionNum > localVersionNum)
            {
                [TYAlertAction showTYAlertActionTitle:@"有最新版本" andMessage:@"您是否更新？" andVc:nil andClick:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        //跳转到App Store
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:VersionDownloadRequest]];
                    }
                }];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
