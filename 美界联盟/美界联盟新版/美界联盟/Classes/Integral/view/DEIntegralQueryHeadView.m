//
//  DEIntegralQueryHeadView.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/24.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import "DEIntegralQueryHeadView.h"

@interface DEIntegralQueryHeadView ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *minTF;
@property (weak, nonatomic) IBOutlet UITextField *maxTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl* segmentedControl;//金币/银币

@end

@implementation DEIntegralQueryHeadView

+(instancetype)CreatDEIntegralQueryHeadView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _segmentedControl.selectedSegmentIndex=0;
    [_segmentedControl addTarget:self action:@selector(SegmentedControlClick:) forControlEvents:UIControlEventValueChanged];
}

-(NSString*)stringWithFormat:(NSString*)text with:(NSString*)string
{
    return [NSString stringWithFormat:@"%@:%@",text,string];
}

-(IBAction)QueryBtnClick:(id)sender
{
    if (self.delegate) {
        [self.delegate queryName:self.nameTF.text phone:self.phoneTF.text min:self.minTF.text max:self.maxTF.text type:_segmentedControl.selectedSegmentIndex];
    }
}


-(IBAction)SegmentedControlClick:(UISegmentedControl*)sender
{
    NSLog(@"---%ld",sender.selectedSegmentIndex);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
