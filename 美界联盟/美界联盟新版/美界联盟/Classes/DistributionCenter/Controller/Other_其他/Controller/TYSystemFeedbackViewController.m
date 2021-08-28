//
//  TYSystemFeedbackViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYSystemFeedbackViewController.h"

@interface TYSystemFeedbackViewController ()<UITextViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UITextView *textTextView;
/** 给textView添加占位 */
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
/** 反馈类型 */
@property (nonatomic, assign) NSInteger type;

//图片视图
@property (weak, nonatomic) IBOutlet UIView *photoView;

@end

@implementation TYSystemFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"系统反馈" andTitleColor:[UIColor whiteColor] andImage:nil];
    self.leftButton.selected = YES;
    self.type = 1;
    self.leftButton.backgroundColor = RGB(20,128,228);
    self.centerButton.selected = NO;
    self.centerButton.backgroundColor = RGB(226, 226, 226);
    self.rightButton.selected = NO;
    self.rightButton.backgroundColor = RGB(226, 226, 226);
    
    //添加三张图片提交
    self.showInView = self.photoView;
    self.maxCount = 3;
    [self initPickerView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma <UITextViewdDelegate>
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    _placeholderLabel.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (_textTextView.text.length != 0) {
        _placeholderLabel.hidden = YES;
    }else{
        _placeholderLabel.hidden = NO;
    }
}

#pragma mark ----点击系统问题
- (IBAction)ClickLeftButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.type = 1;
    if (sender.selected) {
        sender.backgroundColor = RGB(20,128,228);
        self.centerButton.selected = NO;
        self.rightButton.selected = NO;
        self.centerButton.backgroundColor = RGB(226, 226, 226);
        self.rightButton.backgroundColor = RGB(226, 226, 226);
    }else{
        sender.backgroundColor = RGB(226, 226, 226);
    }
}

#pragma mark ----点击功能建议
- (IBAction)ClickCenterButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.type = 2;
    if (sender.selected) {
        sender.backgroundColor = RGB(20,128,228);
        self.leftButton.selected = NO;
        self.rightButton.selected = NO;
        self.leftButton.backgroundColor = RGB(226, 226, 226);
        self.rightButton.backgroundColor = RGB(226, 226, 226);
    }else{
        sender.backgroundColor = RGB(226, 226, 226);
    }
}

#pragma mark ----点击其他
- (IBAction)ClickRightButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.type = 3;
    if (sender.selected) {
        sender.backgroundColor = RGB(20,128,228);
        self.leftButton.selected = NO;
        self.centerButton.selected = NO;
        self.leftButton.backgroundColor = RGB(226, 226, 226);
        self.centerButton.backgroundColor = RGB(226, 226, 226);
    }else{
        sender.backgroundColor = RGB(226, 226, 226);
    }
}

#pragma mark ------ 提交
- (IBAction)ClickSubmit:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.textTextView.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"反馈内容不能为空"];
        return;
    }
    
    if (self.imageArray.count == 0) {
        [self requestFeedback:[NSData data]];
    }else{
        for (int i = 0; i < [self.imageArray count]; ++i) {
            NSData *imageData = UIImageJPEGRepresentation(self.imageArray[i], 1);
            [self requestFeedback:imageData];
        }
    }
}

#pragma mark -- 网络请求
-(void)requestFeedback:(NSData *)data{
    [LoadManager showLoadingView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.type);//反馈类型1系统问题,2功能建议,3其他
    params[@"c"] = self.textTextView.text;//反馈内容
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/msys/feedback",APP_REQUEST_URL];
    
    [TYNetworking postFileDataWithUrl:url parameters:params andconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //上传图片，如果有视频，图片混合上传，就拼接在formData对象里
//        for (int i = 0; i < [self.imageArray count]; i++) {
        
//            NSData *imageData = UIImageJPEGRepresentation(self.imageArray[i], 1);
            
            [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",[TYNetworking timeStampeWithRandom]] mimeType:@"Image/jpg"];
//        }
        
    } andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [TYShowHud showHudSucceedWithStatus:@"上传成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
        
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

@end
