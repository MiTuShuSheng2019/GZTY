//
//  UIImageView+LYExtension.h
//  BangBang
//
//  Created by LY on 2017/6/21.
//  Copyright © 2017年 Banglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LYExtension)

//调用此方法给UIImageView设置圆形头像
-(void)setHead:(NSString *)url;

/******补充说明 可能会有同学会问 为什么不直接操作控件设置呢 两个属性就搞定了 同学你难道不知道直接操作图层来设置圆角 会很耗性能吗？而且会导致你的应用比较卡******/


@end
