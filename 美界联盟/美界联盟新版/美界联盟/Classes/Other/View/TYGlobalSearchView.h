//
//  TYGlobalSearchView.h
//  美界联盟
//
//  Created by LY on 2017/11/18.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

/************全局搜索的View****************/

@protocol TYGlobalSearchViewDelegate <NSObject>

-(void)ClickSearch:(NSString *)KeyWord andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime;


@end

@interface TYGlobalSearchView : UIView

//创建
+(instancetype)CreatTYGlobalSearchView;

/** delegate */
@property (nonatomic, weak) id <TYGlobalSearchViewDelegate> delegate;



@end
