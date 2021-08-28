//
//  DatePickerView.m
//  DatePickerDemo
//
//  Created by 赵朋旭 on 15/11/17.
//  Copyright (c) 2015年 赵朋旭. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()

@property (nonatomic, strong) NSString *selectDate;

@end

@implementation DatePickerView

+ (DatePickerView *)instanceDatePickerView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    NSLocale *locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.datePickerView.locale = locale;
    self.datePickerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.datePickerView.maximumDate=[NSDate date];
    self.datePickerView.minuteInterval=30;
    self.datePickerView.datePickerMode=UIDatePickerModeDate;
}

-(IBAction)sureBtnClick:(id)sender
{
    self.selectDate = [self timeFormat];
    
    [self.delegate changeTimeForDatePickerView:self.selectDate tag:self.tag];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//- (BOOL)isEqualToDate:(NSDate *)otherDate; 与otherDate比较，相同返回YES
//- (NSDate *)earlierDate:(NSDate *)anotherDate; 与anotherDate比较，返回较早的那个日期
//- (NSDate *)laterDate:(NSDate *)anotherDate; 与anotherDate比较，返回较晚的那个日期
+ (BOOL)date:(NSString*)dateStr isStartDate:(NSString*)startDateStr andEndDate:(NSString*)endDateStr dateFormatter:(NSString*)dateFormatter
{
    NSDateFormatter *fm = [[NSDateFormatter alloc]init];
    [fm setDateFormat:dateFormatter];// yyyy-MM-dd yyyyMMdd
    
    NSDate *date = [fm dateFromString:dateStr];
    NSDate *startDate = [fm dateFromString:startDateStr];
    NSDate *endDate = [fm dateFromString:endDateStr];
    
//    NSLog(@"date=%@=%@=%@",date,startDate,endDate);
    if ([date isEqualToDate:startDate] || [[date earlierDate:startDate] isEqualToDate:startDate]) {
        if ([date isEqualToDate:endDate] || [[date laterDate:endDate] isEqualToDate:endDate]) {
            return YES;
        }
    }
    return NO;
}


- (NSString *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self sureBtnClick:nil];
}

-(void)dealloc
{
    self.delegate=nil;
}

@end
