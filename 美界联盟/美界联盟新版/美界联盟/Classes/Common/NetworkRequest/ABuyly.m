//
//  ABuyly.m
//  美界联盟
//
//  Created by LY on 2018/2/5.
//  Copyright © 2018年 刘燚. All rights reserved.
//

static NSString *namePlace = nil;
static ABuyly *aBuyly = nil;

@interface ABuyly()<BuglyDelegate>
@property (nonatomic,assign) AppDelegate * appDelegate;
@end

@implementation ABuyly
+(void) setNamePlace:(NSString *)string{
    namePlace = string;
}
//设置bugly
+(void) buylyWithDelegate:(AppDelegate *) appDelegate{
    if(!aBuyly){
        aBuyly = [ABuyly new];
    }
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    config.reportLogLevel = BuglyLogLevelError;
    config.blockMonitorEnable = YES;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.debugMode = YES;
    config.delegate = aBuyly;
    config.symbolicateInProcessEnable = YES;
    [Bugly startWithAppId:nil config:config];
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
}

- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception{
    [ABuyly buylyException:exception code:1000];
    return namePlace;
}

//上报异常
+ (void)buylyExceptionWithName:(NSExceptionName)name reason:(nullable NSString *)reason userInfo:(nullable NSDictionary *)userInfo {
    NSException *exception = [NSException exceptionWithName:name
                                                     reason:reason
                                                   userInfo:[ABuyly getExceptionDictionary:userInfo]];
    [Bugly reportException:exception];
}

//上报异常
+ (void)buylyException:(NSException *)exception methodName:(NSString *) mtheodName {
    if (!namePlace) {
        namePlace = @"";
    }
    NSString *name = [NSString stringWithFormat:@"namePlace:%@,method:%@,name:%@",namePlace,mtheodName,exception.name];
    NSException *ex = [NSException exceptionWithName:name
                                              reason:exception.reason
                                            userInfo:[ABuyly getExceptionDictionary:exception.userInfo]];
    [Bugly reportException:ex];
}

//上报异常
+ (void)buylyException:(NSException *)exception code:(NSInteger ) code {
    NSString *name = [NSString stringWithFormat:@"code:%lu,%@",code,exception.name];
    NSException *ex = [NSException exceptionWithName:name
                                              reason:exception.reason
                                            userInfo:[ABuyly getExceptionDictionary:exception.userInfo]];
    [Bugly reportException:ex];
}

+(NSDictionary *) getExceptionDictionary:(NSDictionary *)dic{
    NSMutableDictionary *dictionary;
    @try{
        if (dic && dic.count >0) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
            }
        }
        if (!dictionary) {
            dictionary = [NSMutableDictionary dictionaryWithCapacity:100];
        }
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app名称
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        [dictionary setObject:app_Name forKey:@"CFBundleDisplayName"];
        
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [dictionary setObject:app_Version forKey:@"CFBundleShortVersionString"];
        
        // app build版本
        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
        [dictionary setObject:app_build forKey:@"CFBundleVersion"];
        
        //手机系统版本
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        [dictionary setObject:phoneVersion forKey:@"systemVersion"];
        
        // 当前应用名称
        NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        [dictionary setObject:appCurName forKey:@"CFBundleDisplayName"];
        
        // 当前应用软件版本  比如：1.0.1
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [dictionary setObject:appCurVersion forKey:@"CFBundleShortVersionString"];
        
        // 当前应用版本号码   int类型
        NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
        [dictionary setObject:appCurVersionNum forKey:@"CFBundleVersion"];
    }@catch(NSException *e){
        [ABuyly buylyException:e code:17];
    }
    return dictionary;
}

#pragma mark 抛物线动画,新增一个动画view在supView上，做动画的事新增的图层
+(void)throwView:(UIView *)obj toPoint:(CGPoint)end height:(CGFloat)height duration:(CGFloat)duration delegate:(id <CAAnimationDelegate>) delegate supView:(UIView *)supView{
    CGRect rect = [self getWindowRectFromBounds:obj];
    //添加动画图层，位置随意，在屏幕之外是为了防止动画结束之后会出现图层在原来位置闪动一下
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-100, -100, rect.size.width, rect.size.height)];
    [view setBackgroundColor:[UIColor colorWithPatternImage:[self makeImageWithView:obj withSize:obj.frame.size]]];
    [supView addSubview:view];
    //初始化抛物线的路径
    CGPoint start = CGPointMake(rect.origin.x +rect.size.width/2, rect.origin.y+rect.size.height/2);
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat cpx = (start.x + end.x) / 2;
    CGFloat cpy = start.y;
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, end.x, end.y);
    //路径动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    //比例动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.6];
    //将动画放到动画Group中，设置动画参数
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.delegate = delegate;
    groupAnimation.repeatCount = 1;
    groupAnimation.duration = duration;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.animations = @[scaleAnimation,animation];
    [view.layer addAnimation:groupAnimation forKey:nil];
    
    //定时释放动画突出
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, duration*NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        view.hidden = YES;
        [view removeFromSuperview];
    });
}

#pragma mark 获取view在屏幕上的位置
+(CGRect) getWindowRectFromBounds:(UIView *)bView{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[bView convertRect: bView.bounds toView:window];
    return rect;
}

#pragma mark 根据view生成image
+ (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

#pragma mark 水平滚动动画，滚动
+(void)rollView:(UIView *)obj toFrame:(CGRect)frame duration:(CGFloat)duration{
    [UIView animateWithDuration:duration animations:^{
        obj.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    [obj inputView];
}


//+(void) buylyNetWorkTimeForm:(NSDate *)start name:(NSString *)name urlPath:(NSString *)urlPaht mark:(NSString *)mark {
//    NSDate *end = [NSDate date];
//    @try{
//        NSTimeInterval interval = [start timeIntervalSinceDate:end];
//        if ([ADefaultModel defaultModel]) {
//            if ([ADefaultModel defaultModel].statistics) {
//                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                //设定时间格式,这里可以设置成自己需要的格式
//                [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
//                [ABuyly buylyExceptionWithName:name reason:[NSString stringWithFormat:@"开始:%@,结束:%@,urlPath:%@}",[dateFormatter stringFromDate:start],[dateFormatter stringFromDate:end],urlPaht] userInfo:@{}];
//            }
//        }
//
//        if (interval > 2) {
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            //设定时间格式,这里可以设置成自己需要的格式
//            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
//            [ABuyly buylyExceptionWithName:name reason:[NSString stringWithFormat:@"开始:%@,结束:%@,urlPath:%@}",[dateFormatter stringFromDate:start],[dateFormatter stringFromDate:end],urlPaht] userInfo:@{}];
//        }
//    }@catch(NSException *e){
//        [ABuyly buylyException:e code:18];
//    }
//}
//
//+(void) buylyNetWorkTimeForm:(NSDate *)start name:(NSString *)name urlPath:(NSString *)urlPaht mark:(NSString *)mark time:(NSInteger )time{
//    NSDate *end = [NSDate date];
//    @try{
//        NSTimeInterval interval = [start timeIntervalSinceDate:end];
//        if ([ADefaultModel defaultModel]) {
//            if ([ADefaultModel defaultModel].statistics) {
//                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                //设定时间格式,这里可以设置成自己需要的格式
//                [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
//                [ABuyly buylyExceptionWithName:name reason:[NSString stringWithFormat:@"开始:%@,结束:%@,urlPath:%@}",[dateFormatter stringFromDate:start],[dateFormatter stringFromDate:end],urlPaht] userInfo:@{}];
//            }
//        }
//        if (interval > time) {
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            //设定时间格式,这里可以设置成自己需要的格式
//            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
//            [ABuyly buylyExceptionWithName:name reason:[NSString stringWithFormat:@"开始:%@,结束:%@,urlPath:%@}",[dateFormatter stringFromDate:start],[dateFormatter stringFromDate:end],urlPaht] userInfo:@{}];
//        }
//    }@catch(NSException *e){
//        [ABuyly buylyException:e code:19];
//    }
//}

@end
