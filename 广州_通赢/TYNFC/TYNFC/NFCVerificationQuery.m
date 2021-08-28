//
//  NFCVerificationQuery.m
//  TYNFC
//
//  Created by LY on 2018/1/15.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import "NFCVerificationQuery.h"

@interface NFCVerificationQuery ()

@property (weak, nonatomic) IBOutlet UILabel *NFCLabel;

@end

@implementation NFCVerificationQuery

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    
    [self setNavigationBarTitle:@"NFC防伪查询" andTitleColor:[UIColor whiteColor] andImage:nil];
    self.NFCLabel.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.NFCLabel.text = self.resultStr;
}

//返回按钮被点击时的动作。
- (void)navigationBackBtnClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
