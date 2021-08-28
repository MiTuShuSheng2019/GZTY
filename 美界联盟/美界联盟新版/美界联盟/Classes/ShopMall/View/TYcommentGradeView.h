//
//  TYcommentGradeView.h
//  美界联盟
//
//  Created by LY on 2017/12/22.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYcommentGradeView;
typedef void(^finishBlock)(CGFloat currentScore);
typedef NS_ENUM(NSInteger, RateStyle)
{
    RateStyleWholeStar = 0, //只能整星评论
    RateStyleHalfStar = 1,  //允许半星评论
    RateStyleIncompleteStar = 2  //允许不完整星评论
};
@protocol TYcommentGradeViewDelegate<NSObject>
-(void)starRateView:(TYcommentGradeView *)starRateView currentScore:(CGFloat)currentScore;
@end

@interface TYcommentGradeView : UIView
@property (nonatomic, assign) BOOL isAnimation;       //是否动画显示，默认NO
@property (nonatomic, assign) RateStyle rateStyle;    //评分样式    默认是WholeStar
@property (nonatomic, assign) CGFloat currentScore;   // 当前评分默认0
@property (nonatomic, weak) id<TYcommentGradeViewDelegate> delegate;

/**
 *通过代理的方法获取当前评分数currentScore
 */
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate;

/**
 *通过Block传值的方法获取当前评分数currentScore
 */
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;

#pragma mark 设置代理传值参数
-(void) setNumberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate;

#pragma mark 设置block传值参数
-(void) setNumberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;

-(void)setCurrentScore:(CGFloat)currentScore ;

@end
