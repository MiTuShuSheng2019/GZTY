//
//  TYAuthorizationView.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYAuthorizationView.h"

@interface TYAuthorizationView()



@end


@implementation TYAuthorizationView

+(instancetype)CreatTYAuthorizationView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.5];
   
}

-(void)setIsRequest:(BOOL)isRequest{
    _isRequest = isRequest;
    if (self.isRequest == YES) {
        [self requestGetTYCertificate];
    }
}

//保存
- (IBAction)ClickSave {
    //图片保存到本地
    [self saveImageToPhotos:self.AuthorizationImageView.image];
}

//实现该方法
- (void)saveImageToPhotos:(UIImage*)savedImage{
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}


//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if(error != NULL){
        [TYShowHud showHudErrorWithStatus:@"保存图片失败"];
    }else{
        [TYShowHud showHudSucceedWithStatus:@"保存图片成功"];
    }
    [self removeFromSuperview];
}


#pragma mark - 保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSString * pathString = [NSString stringWithFormat:@"Documents/%@",imageName];
    //设置照片的品质
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    
    // 获取沙盒目录
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:pathString];
    // 将图片写入文件
    [imageData writeToFile:filePath atomically:NO];
    //将选择的图片显示出来
}

//取消
- (IBAction)ClickCance {
    [self removeFromSuperview];
}

#pragma mark -- 网络请求
//59 经销中心 获取授权证书
-(void)requestGetTYCertificate{
    [LoadManager showLoadingView:self];
    NSString *tel = [TYLoginModel getPhone];
    if (tel.length == 0) {
        tel = [TYLoginModel getWeiXing];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @"";//条码小标
    params[@"c"] = tel;// tel或者微信
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/GetTYCertificate",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            //处理回文
            NSString *encodedImageStr = [respondObject objectForKey:@"c"];
            NSRange range = [encodedImageStr rangeOfString:@"base64,"];
            encodedImageStr = [encodedImageStr substringFromIndex:range.location+range.length];
            NSData *imageData = [[NSData alloc]
                                 initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *image = [UIImage imageWithData:imageData];
            self.AuthorizationImageView.image = image;
            
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

@end
