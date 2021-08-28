//
//  CreateCode.m
//  BangBang
//
//  Created by LY on 16/10/8.
//  Copyright © 2016年 Banglin. All rights reserved.
//

#import "CreateCode.h"

@implementation CreateCode
-(CIImage *)createGeneralCode{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
        
    // 3.给过滤器添加数据(正则表达式/账号和密码)
//    NSString *dataString = [NSString stringWithFormat:@"%@%@",self.url,self.content];//添加想要的信息内容
    NSString *dataString = self.url;
    
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    return outputImage;
}

-(void)ddd{
    
}
@end
