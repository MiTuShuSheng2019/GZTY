//
//  TYShareView.m
//  美界联盟
//
//  Created by LY on 2017/10/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShareView.h"

@interface TYShareView ()<WXApiDelegate>

@property (weak, nonatomic) IBOutlet UIButton *againBtn;

@end

@implementation TYShareView

+(instancetype)CreatTYShareView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
    [self addGestureRecognizer:tap];
}

//点击非弹框区域去取消
-(void)cancelView{
    [self ClickCance];
}

//分享到聊天界面
- (IBAction)ClcikWeiChat {
    [self sendLinkContent:WXSceneSession title:@"美界联盟" descrip:@"为您分享一条产品链接！" link:[TYNetworking getShrpeProductUrlDistributionID:self.distributionID prodcutID:self.prodcutID] image:nil];
    
}

//分享到朋友圈
- (IBAction)ClickFriendCircle {
    
    [self sendLinkContent:WXSceneTimeline title:@"美界联盟" descrip:@"为您分享一条产品链接！" link:[TYNetworking getShrpeProductUrlDistributionID:self.distributionID prodcutID:self.prodcutID] image:nil];
    
}

//取消
- (IBAction)ClickCance {
    [self removeFromSuperview];
}

#pragma mark 微信分享
- (void) sendLinkContent:(enum WXScene )scene title:(NSString *)title descrip:(NSString *)des link:(NSString *)link image:(UIImage *)image
{
    @try{
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = des;
        if (!image) {
            image = [UIImage imageNamed:@"app_logo.png"];
        }
        [message setThumbImage:image];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = link;
        message.mediaObject = ext;
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        [WXApi sendReq:req];
    }@catch(NSException *e){
        [ABuyly buylyException:e code:10];
    }@finally {
        NSString* url =[NSString stringWithFormat:@"%@mapi/Intergral/MShare",APP_REQUEST_URL];
        NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
        if (!phone) {
            phone = @"";
        }
        NSDictionary* params = @{@"a":phone};
        [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
            
        } withSuccessBlock:^(id respondObject) {
            
            if ([[respondObject objectForKey:@"a"]integerValue] != TYRequestSuccessful) {
                [ShowMessage showMessage:[respondObject objectForKey:@"b"]];
            }
        } orFailBlock:^(id error) {
            //        [TYShowHud showHudErrorWithStatus:@"网络超时，请重新再试"];
        }];
    }
    [self removeFromSuperview];
}

//-(void)onResp:(BaseResp *)resp
//{
//    NSString* url =[NSString stringWithFormat:@"%@mapi/Intergral/MShare",APP_REQUEST_URL];
//    NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
//    if (!phone) {
//        phone = @"";
//    }
//    NSDictionary* params = @{@"a":phone};
//    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
//        
//    } withSuccessBlock:^(id respondObject) {
//        
//        if ([[respondObject objectForKey:@"a"]integerValue] == 1) {
//            [ShowMessage showMessage:[respondObject objectForKey:@"b"]];
//        }
//    } orFailBlock:^(id error) {
//        //        [TYShowHud showHudErrorWithStatus:@"网络超时，请重新再试"];
//    }];
//}

@end
