//
//  TYGlobalSearchView.m
//  美界联盟
//
//  Created by LY on 2017/11/18.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "DEGlobalSearchView.h"
#import "SZCalendarPicker.h"

@interface DEGlobalSearchView ()<UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;

//关键字搜索
@property (weak, nonatomic) IBOutlet UITextField *KeyWordTextField;
//开始时间
@property (weak, nonatomic) IBOutlet UITextField *StartTimeTextField;
//结束时间
@property (weak, nonatomic) IBOutlet UITextField *EndTimeTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl* segmentedControl;

/** 日期选择视图 */
@property (nonatomic, strong) SZCalendarPicker *calendarPicker;

@end

@implementation DEGlobalSearchView

+(instancetype)CreatDEGlobalSearchView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.StartTimeTextField.delegate = self;
    self.EndTimeTextField.delegate = self;
    
}

#pragma mark -- <UIGestureRecognizerDelegate>
//实现此代理是为了防止点击弹框区域视图也消失
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.backView] || [touch.view isDescendantOfView:self.calendarPicker]) {
        return NO;
    }
    return YES;
}

#pragma mark -- <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self endEditing:YES];
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self];
    self.calendarPicker = calendarPicker;
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, KScreenWidth, 352);
    if (textField == self.StartTimeTextField) {
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
            self.StartTimeTextField.text = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
        };
    }
    
    if (textField == self.EndTimeTextField) {
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
            self.EndTimeTextField.text = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
        };
    }
    return NO;
}

//点击非弹框区域去取消
-(void)cancelView{
    [self removeFromSuperview];
}

//清除时间
- (IBAction)ClickRemoveTime {
    self.StartTimeTextField.text = nil;
    self.EndTimeTextField.text = nil;
}

//时间搜索
- (IBAction)ClickTimeSearch {
    NSString *selectedSegmentIndex=[NSString stringWithFormat:@"%ld",self.segmentedControl.selectedSegmentIndex];
    if (_delegate && [_delegate respondsToSelector:@selector(ClickSearch:andStartTime:andEndTime:andType:)]) {
        [_delegate ClickSearch:self.KeyWordTextField.text andStartTime:self.StartTimeTextField.text andEndTime:self.EndTimeTextField.text andType:selectedSegmentIndex];
    }
    [self cancelView];
    
}

@end
