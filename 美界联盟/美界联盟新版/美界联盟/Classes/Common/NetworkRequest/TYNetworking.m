//
//  TYNetworking.m
//  美界app
//
//  Created by LY on 2017/10/20.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYNetworking.h"

@implementation TYNetworking

+(AFHTTPSessionManager *)manager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0f;//请求超时用，你也可以上网百度下，设置你请求要用的，这里还可以设置请求头里面的很多参数
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
   
    
    return manager;
}

+(void)hasNet:(isNetBlock)yesOrNoNetBlock{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                yesOrNoNetBlock(@"未知网络");
                break;
            case 0:
                yesOrNoNetBlock(@"请检测网络是否连接");
                break;
            case 1:
                yesOrNoNetBlock(@"GPRS网络");
                break;
            case 2:
                yesOrNoNetBlock(@"wifi网络");
                break;
            default:
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
}


+(void)getRequestURL:(NSString *)url parameters:(NSDictionary *)parameters andProgress:(ProgressBlock)progress withSuccessBlock:(SuccessBlock)successObject orFailBlock:(FailBlock)failObject{
    [self.manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //回调下载进度
        progress(downloadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //json转字典，外面直接用字典，数据已经解析好了
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        //成功回调数据
        successObject(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //回调错误信息
        failObject(error);
    }];
}



+(void)postRequestURL:(NSString *)url parameters:(id)parameters andProgress:(ProgressBlock)progress withSuccessBlock:(SuccessBlock)successObject orFailBlock:(FailBlock)failObject{
    
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度进度
        progress(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        successObject(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failObject(error);
    }];
}

+(void)postFileDataWithUrl:(NSString *)url parameters:(id)parameters andconstructingBodyWithBlock:(ConstructingBodyBlock)constructingBodyBlock andProgress:(ProgressBlock)progress withSuccessBlock:(SuccessBlock)successObject orFailBlock:(FailBlock)failObject{
    
    [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //AFMultipartFormData 对象传递出去  获取要上传的数据
        constructingBodyBlock (formData);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        successObject(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failObject(error);
        
    }];
}

//利用时间戳命名图片  避免图片在服务器中重名
+(NSString *)timeStampeWithRandom{
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    return [NSString stringWithFormat:@"%f%ld",now,random()%1000];
}

/**********分享时调用**********/
/*
 * disId 分销商主键id
 * prodcutID 产品id
*/
+(NSString *) getShrpeProductUrlDistributionID:( NSInteger)disId prodcutID:( NSInteger)pId{
    return [NSString stringWithFormat:@"%@APP/SMMall/Index?a=%ld&b=%ld",APP_REQUEST_URL,(long)disId, (long)pId];
    
}


@end
