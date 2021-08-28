//
//  UIButton+TYButton.m
//  美界APP
//
//  Created by TY-DENG on 17/8/3.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "UIButton+TYButton.h"
//#import "ATool.h"
#import <objc/runtime.h>
static char strAddrKey = 'a';
#define ConrnerLabelTag 4001
@implementation UIButton (TYButton)
- (void)setKey:(NSInteger )key{
    objc_setAssociatedObject(self, &strAddrKey, [NSNumber numberWithInteger:key], OBJC_ASSOCIATION_COPY);
}

- (NSInteger)key{
    return [objc_getAssociatedObject(self, &strAddrKey) integerValue];
}

-(void) addButtonCornerLabelColor:(UIColor *)color string:(NSString *)message{
    NSString *string = [self titleForState:UIControlStateNormal];
    float value1 =  [self widthForString:string fontSize:15 andHeight:15];
    float value2 =  [self widthForString:message fontSize:12 andHeight:12]+10;
    if(value2 < 20.0){
        value2 = 20.0;
    }
    UILabel *label = [self viewWithTag:ConrnerLabelTag];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width+ value1)/2, 0, value2, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.tag = ConrnerLabelTag;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        [self setView:label styleBackgroundColor:nil cornerRadius:10 LayerWidth:0 Color:nil];
    }else{
        label.hidden = NO;
    }
    if (message && message.length > 0) {
         [label setText:message];
    }else{
        label.hidden = YES;
    }
    
    if (color) {
        label.backgroundColor = color;
    }
    
}

#pragma mark 求文笔宽
- (float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT,height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.width;
}

#pragma mark 设置view 样式
-(void) setView:(UIView *)view styleBackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat) radius LayerWidth:(CGFloat) width Color:(UIColor *)borderColor{
    if (radius > 0) {
        view.layer.cornerRadius = radius;
        view.layer.masksToBounds = YES;
    }
    if (width > 0) {
        view.layer.borderWidth = width;
    }
    if (borderColor) {
        view.layer.borderColor = borderColor.CGColor;
    }
    if (backgroundColor) {
        [view setBackgroundColor:backgroundColor];
    }
}
@end
