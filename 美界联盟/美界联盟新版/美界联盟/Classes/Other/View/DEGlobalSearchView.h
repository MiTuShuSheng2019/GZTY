//
//  TYGlobalSearchView.h
//  美界联盟
//
//  Created by LY on 2017/11/18.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

/************全局搜索的View****************/

@protocol DEGlobalSearchViewDelegate <NSObject>

-(void)ClickSearch:(NSString *)KeyWord andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andType:(NSString*)type;


@end

@interface DEGlobalSearchView : UIView

//创建
+(instancetype)CreatDEGlobalSearchView;

/** delegate */
@property (nonatomic, weak) id <DEGlobalSearchViewDelegate> delegate;



@end
