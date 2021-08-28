//
//  DETextScrollView.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/9/17.
//  Copyright © 2019 刘燚. All rights reserved.
//

#import "DETextScrollView.h"
#import "LMJHorizontalScrollText.h"

@interface DETextScrollView ()

@property (nonatomic, strong) LMJHorizontalScrollText * scrollText3_1;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation DETextScrollView
{
    CGFloat _screenWidth;
    UIColor * _bgColor;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self creatUI];
        [self scrollText3_1];
    }
    return self;
}

-(LMJHorizontalScrollText*)scrollText3_1
{
    if (!_scrollText3_1) {
        _screenWidth = self.frame.size.width;
        _bgColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        
        _scrollText3_1 = [[LMJHorizontalScrollText alloc] initWithFrame: CGRectMake(0, 0, _screenWidth, 20)];
        _scrollText3_1.layer.cornerRadius = 3;
        _scrollText3_1.backgroundColor    = _bgColor;
        //    _scrollText3_1.text               = @"";
        _scrollText3_1.textColor          = [UIColor whiteColor];
        _scrollText3_1.textFont           = [UIFont systemFontOfSize:14];
        _scrollText3_1.speed              = 0.03;
        _scrollText3_1.moveDirection      = LMJTextScrollMoveLeft;
        _scrollText3_1.moveMode           = LMJTextScrollIntermittent;
        [self addSubview:_scrollText3_1];
        
        [self addSubview:_scrollText3_1];
        _scrollText3_1.textScrollBlock = ^() {
            if (_delegate && [_delegate respondsToSelector:@selector(DETextScrollViewShare)]) {
                [self.delegate DETextScrollViewShare];
            }
        };
    }
    return _scrollText3_1;
}

-(void)setText:(NSString *)text timer:(NSInteger)timer
{
    _scrollText3_1.text               = text;
    _scrollText3_1.moveMode           = LMJTextScrollIntermittent;
    _timer = [NSTimer scheduledTimerWithTimeInterval:timer target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];

    [_scrollText3_1 move];
}

-(void)scrollTimer
{
    [_timer invalidate];
    _timer = nil;
    [_scrollText3_1 stop];
    [self removeAllSubviews];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [_timer invalidate];
        _timer = nil;
        [_scrollText3_1 stop];
        _delegate = nil;
        [self removeAllSubviews];
    }
    [super willMoveToSuperview:newSuperview];
}

@end
