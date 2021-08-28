//
//  DEIntegralExchangeQueryHeadView.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/24.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import "DEIntegralExchangeQueryHeadView.h"
#import "DatePickerView.h"

@interface DEIntegralExchangeQueryHeadView ()<DatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UILabel *date1Label;
@property (weak, nonatomic) IBOutlet UILabel *date2Label;
@property (weak, nonatomic) IBOutlet UISegmentedControl* segmentedControl;//金币/银币

@property (weak, nonatomic) DatePickerView* datePV;

@end

@implementation DEIntegralExchangeQueryHeadView

+(instancetype)CreatDEIntegralExchangeQueryHeadView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _segmentedControl.selectedSegmentIndex=0;
//    [_segmentedControl addTarget:self action:@selector(SegmentedControlClick:) forControlEvents:UIControlEventValueChanged];
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
    self.date1Label.userInteractionEnabled=YES;
    [self.date1Label addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
    self.date2Label.userInteractionEnabled=YES;
    [self.date2Label addGestureRecognizer:tap2];
    
    self.date1Label.layer.borderColor = [RGB(238, 238, 238) CGColor];
    self.date1Label.layer.borderWidth = 1.0;
    self.date1Label.layer.cornerRadius = 5;
    [self.date1Label.layer setMasksToBounds:YES];
    
    self.date2Label.layer.borderColor = [RGB(238, 238, 238) CGColor];
    self.date2Label.layer.borderWidth = 1.0;
    self.date2Label.layer.cornerRadius = 5;
    [self.date2Label.layer setMasksToBounds:YES];
}

-(void)tap1
{
    _datePV = [DatePickerView instanceDatePickerView];
    _datePV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_datePV setBackgroundColor:[UIColor clearColor]];
    _datePV.timeTitle.text=@"选择日期";
    _datePV.tag=101;
    _datePV.delegate = self;
    [self.superview addSubview:_datePV];
}

-(void)tap2
{
    _datePV = [DatePickerView instanceDatePickerView];
    _datePV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_datePV setBackgroundColor:[UIColor clearColor]];
    _datePV.timeTitle.text=@"选择日期";
    _datePV.tag=102;
    _datePV.delegate = self;
    [self.superview addSubview:_datePV];
}

-(void)changeTimeForDatePickerView:(NSString *)date tag:(NSUInteger)Tag
{
    if (Tag == 101) {
        self.date1Label.text = date;
    }else {
        self.date2Label.text = date;
    }
}

-(NSString*)stringWithFormat:(NSString*)text with:(NSString*)string
{
    return [NSString stringWithFormat:@"%@:%@",text,string];
}

-(IBAction)QueryBtnClick:(id)sender
{
    if (self.delegate) {
        [self.delegate queryName:self.nameTF.text phone:self.phoneTF.text Date:self.date1Label.text witnDate:self.date2Label.text type:_segmentedControl.selectedSegmentIndex];
    }
}

//-(DatePickerView*)datePV
//{
//    if (_datePV) {
//        _datePV = [DatePickerView instanceDatePickerView];
//        _datePV.delegate=self;
//    }
//    return _datePV;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
