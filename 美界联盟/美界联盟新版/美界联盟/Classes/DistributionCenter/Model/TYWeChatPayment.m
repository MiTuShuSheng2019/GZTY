//
//  TYWeChatPayment.m
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYWeChatPayment.h"
#import<CommonCrypto/CommonDigest.h>

@implementation TYWeChatPayment

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static TYWeChatPayment *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TYWeChatPayment alloc] init];
    });
    return instance;
}

//- (void)dealloc {
//    self.delegate = nil;
//    [super dealloc];
//}

+ (void)jumpToBizPay:(NSDictionary *)dict {
    
    //调起微信支付
    PayReq *req             = [[PayReq alloc] init];
    
    req.partnerId           = [NSString stringWithFormat:@"%@",[dict objectForKey:@"partnerid"]];
    
    req.prepayId            = [NSString stringWithFormat:@"%@",[dict objectForKey:@"prepayid"]];
    
    req.nonceStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"noncestr"]];
    
    req.package = [NSString stringWithFormat:@"%@",[dict objectForKey:@"package"]];
    
    req.openID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"appid"]];
    
    //将当前事件转化成时间戳
    //    NSDate *datenow = [NSDate date];
    //    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    //    UInt32 timeStamp =[timeSp intValue];
    
    //    req.timeStamp= timeStamp;
    //
    //    req.sign = [self creatMD5SingForPar:req.openID partnerid:req.partnerId prepayid:req.prepayId package:req.package noncestr:req.nonceStr timestamp:req.timeStamp];
    
    //用的后台签名
    req.timeStamp = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"timestamp"]] intValue];
    req.sign = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sign"]];
    
    [WXApi sendReq:req];
    //日志输出
    //    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%d\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,req.timeStamp,req.package,req.sign );
}

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        
        switch (resp.errCode) {
            case WXSuccess:
                
                //NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                if (_delegate && [_delegate respondsToSelector:@selector(paySucceed:)]) {
                    [_delegate paySucceed:WXSuccess];
                }
                break;
            case WXErrCodeCommon:
                
                if (_delegate && [_delegate respondsToSelector:@selector(PayFailure:)]) {
                    [_delegate PayFailure:WXErrCodeCommon];
                }
                [self FailureShow];
                break;
                
            case WXErrCodeUserCancel:
                if (_delegate && [_delegate respondsToSelector:@selector(PayFailure:)]) {
                    [_delegate PayFailure:WXErrCodeUserCancel];
                }
                [self FailureShow];
                break;
                
                
            default:
                
                //                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                [self FailureShow];
                break;
        }
    }
}

-(void)FailureShow{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark -  微信支付本地签名
+ (NSString *)creatMD5SingForPar:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key{
    
    //签名（这个签名可以自己进行签名，也可以后台操作，由后台返回）
    NSMutableDictionary *signParams=[[NSMutableDictionary alloc] init];
    [signParams setObject: appid_key        forKey:@"appid"];
    [signParams setObject: noncestr_key    forKey:@"noncestr"];
    [signParams setObject: package_key      forKey:@"package"];
    [signParams setObject: partnerid_key        forKey:@"partnerid"];
    [signParams setObject: [NSString stringWithFormat:@"%u",timestamp_key]   forKey:@"timestamp"];
    [signParams setObject: prepayid_key     forKey:@"prepayid"];
    
    NSString * result = [self createMd5Sign:signParams];
    
    return result;
}

+ (NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    
    //添加key字段
    [contentString appendFormat:@"key=%@", @"721A05D7C2D64082B7AE088CC700CD43"];
    
    NSString *md5Sign =[self md5:contentString];
    
    return md5Sign;
}

#pragma mark - md5加密
+ (NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

@end

