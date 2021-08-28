//
//  DEIntegralQueryHeadView.h
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/24.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DEIntegralQueryHeadViewDelegate <NSObject>
//点击分享
-(void)queryName:(NSString*)name phone:(NSString*)phone min:(NSString*)min max:(NSString*)max type:(NSInteger)type;

@end

@interface DEIntegralQueryHeadView : UIView

//调用此方法创建DEIntegralQueryHeadView
+(instancetype)CreatDEIntegralQueryHeadView;

@property (weak, nonatomic) NSDictionary *dictionary;

@property(nonatomic,assign) id<DEIntegralQueryHeadViewDelegate> delegate;

@end
