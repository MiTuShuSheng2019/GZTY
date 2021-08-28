//
//  TYAuthorizationView.h
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYAuthorizationView : UIView

//创建
+(instancetype)CreatTYAuthorizationView;

/** 是否需要进行网络请求 YES需要 */
@property (nonatomic, assign) BOOL isRequest;

@property (weak, nonatomic) IBOutlet UIImageView *AuthorizationImageView;

@end
