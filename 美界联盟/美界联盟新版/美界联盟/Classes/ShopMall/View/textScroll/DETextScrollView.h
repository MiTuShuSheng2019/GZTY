//
//  DETextScrollView.h
//  美界联盟
//
//  Created by Glory_iMac on 2019/9/17.
//  Copyright © 2019 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DETextScrollViewDelegate <NSObject>
//点击分享
-(void)DETextScrollViewShare;
@end


@interface DETextScrollView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

-(void)setText:(NSString *)text timer:(NSInteger)timer;

@property (nonatomic, weak) id <DETextScrollViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
