//
//  TYNetworking.h
//  美界app
//
//  Created by LY on 2017/10/20.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TYRequestType) {
    TYRequestSuccessful = 0, //请求成功
};

typedef void (^SuccessBlock)(id respondObject);

typedef void (^FailBlock)(id error);

typedef void (^ProgressBlock)(double progress);

typedef void (^ConstructingBodyBlock)(id<AFMultipartFormData> formData);

typedef void (^isNetBlock)(id status);

@interface TYNetworking : NSObject

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

//利用时间戳命名图片  避免图片在服务器中重名
+(NSString *)timeStampeWithRandom;

/**********分享时调用**********/
/*
 * disId 分销商主键id
 * prodcutID 产品id
 */
+(NSString *)getShrpeProductUrlDistributionID:( NSInteger)disId prodcutID:( NSInteger)pId;

@end
