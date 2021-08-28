//
//  DatePickerView.h
//  DatePickerDemo
//
//  Created by 赵朋旭 on 15/11/17.
//  Copyright (c) 2015年 赵朋旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

-(void)changeTimeForDatePickerView:(NSString*)date tag:(NSUInteger)Tag;

@end

@interface DatePickerView : UIView
@property (strong,nonatomic) IBOutlet UIButton *sureBtn;

@property (strong,nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (strong,nonatomic) IBOutlet UILabel *timeTitle;

@property (assign,nonatomic) id <DatePickerViewDelegate> delegate;


+ (DatePickerView *)instanceDatePickerView;
//@property (nonatomic, assign) DateType type;

+ (BOOL)date:(NSString*)dateStr isStartDate:(NSString*)startDateStr andEndDate:(NSString*)endDateStrv dateFormatter:(NSString*)dateFormatter;


@end
