//
//  TYShareQrCodeView.h
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYShareQrCodeView : UIView

//创建
+(instancetype)CreatTYShareQrCodeView;

@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

/** 分享链接 */
@property (nonatomic, strong) NSString *shareLink;

@end
