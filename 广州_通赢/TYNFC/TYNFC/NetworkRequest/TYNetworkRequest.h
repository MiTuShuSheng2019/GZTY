//
//  TYNetworkRequest.h
//  TYNFC
//
//  Created by LY on 2018/1/4.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id respondObject);

typedef void (^FailBlock)(id error);

typedef void (^ProgressBlock)(double progress);

typedef void (^ConstructingBodyBlock)(id<AFMultipartFormData> formData);

typedef void (^isNetBlock)(id status);

@interface TYNetworkRequest : NSObject

/*
 ***网络状态监听，设置block回调
 */
+(void)hasNet:(isNetBlock)yesOrNoNetBlock;



/*
 ***GET 请求
 ***url             接口地址
 ***parameters      参数
 ***progress        获取数据进度 0--1之间
 ***successObject   成功回调
 ***failObject      失败回调
 */
+(void)getRequestURL:(NSString *)url parameters:(id)parameters andProgress:(ProgressBlock)progress withSuccessBlock:(SuccessBlock)successObject orFailBlock:(FailBlock)failObject;



/*
 ***普通的 POST 请求 无文件上传的post
 ***url             接口地址
 ***parameters      参数
 ***progress        上传数据进度 0--1之间
 ***successObject   成功回调
 ***failObject      失败回调
 */
+(void)postRequestURL:(NSString *)url parameters:(id)parameters andProgress:(ProgressBlock)progress withSuccessBlock:(SuccessBlock)successObject orFailBlock:(FailBlock)failObject;




/*
 ***POST 上传数据
 ***url             接口地址
 ***parameters      参数
 ***progress        获取数据进度 0--1之间
 ***successObject   成功回调
 ***failObject      失败回调
 */
+(void)postFileDataWithUrl:(NSString *)url parameters:(id)parameters andconstructingBodyWithBlock:(ConstructingBodyBlock)constructingBodyBlock andProgress:(ProgressBlock)progress withSuccessBlock:(SuccessBlock)successObject orFailBlock:(FailBlock)failObject;

@end
