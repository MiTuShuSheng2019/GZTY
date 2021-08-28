//
//  TYBootPageView.m
//  美界APP
//
//  Created by TY-DENG on 2017/10/8.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYBootPageView.h"

@implementation TYBootPageView

#pragma mark 展示引导页，默认应用展示一次
+(void) showForView{
    NSString *key = @"meijieappbootPage";
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!str) {
         [[NSUserDefaults standardUserDefaults] setObject:@"bootPage" forKey:key];
        TYBootPageView *bootView = DF_NSBoundLoadXib(@"BootPage");
        bootView.frame =  [UIApplication sharedApplication].keyWindow.frame;
        bootView.buttonMaginBottomLC.constant = [UIApplication sharedApplication].keyWindow.frame.size.height * 0.078;
        bootView.buttonHeightLC.constant = [UIApplication sharedApplication].keyWindow.frame.size.height * 0.058;
        [bootView inputView];
        [ [UIApplication sharedApplication].keyWindow addSubview:bootView];
    }
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}


@end
