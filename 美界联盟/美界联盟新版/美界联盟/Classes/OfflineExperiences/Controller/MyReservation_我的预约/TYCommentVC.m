//
//  TYCommentVC.m
//  美界联盟
//
//  Created by LY on 2017/11/29.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYCommentVC.h"


@interface TYCommentVC ()
//评分View
@property (weak, nonatomic) IBOutlet TYcommentGradeView *starView;
//分数
@property (weak, nonatomic) IBOutlet UILabel *starLabel;

@property (nonatomic, assign) CGFloat star;
//内容
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
//图片视图
@property (weak, nonatomic) IBOutlet UIView *photoView;
/** 给textView添加占位 */
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation TYCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"评论" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    
    [self.starView setCurrentScore:0];
    [self.starView setNumberOfStars:5 rateStyle:RateStyleHalfStar isAnination:YES finish:^(CGFloat currentScore) {
        self.star = currentScore;
        [_starLabel setText:[NSString stringWithFormat:@"%.1lf分",currentScore]];
    }];
    
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
    
    if (_contentTextView.text.length != 0) {
        _placeholderLabel.hidden = YES;
    }else{
        _placeholderLabel.hidden = NO;
    }
}


#pragma mark -- 提交
- (IBAction)ClickCommentAdd {
    if (self.star <= 0) {
        [TYShowHud showHudErrorWithStatus:@"请先评分"];
        return;
    }
    [self requestCommentAdd];
}

#pragma mark -- 网路请求
//86 线下体验 提交评论
- (void)requestCommentAdd{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   
    params[@"b"] = @(self.model.ea);//体验预约单id
    params[@"c"] = @(self.star);//评分
    params[@"d"] = self.contentTextView.text;//评论内容
   
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/CommentAdd",APP_REQUEST_URL];
    
    [TYNetworking postFileDataWithUrl:url parameters:params andconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //上传图片，如果有视频，图片混合上传，就拼接在formData对象里
        for (int i=0; i<[self.imageArray count]; i++) {
            
            NSData *imageData = UIImageJPEGRepresentation(self.imageArray[i], 1);
            [formData appendPartWithFileData:imageData name:@"PicUrl" fileName:[NSString stringWithFormat:@"%@_%@_%d.jpg",@"1",[TYNetworking timeStampeWithRandom],i] mimeType:@"image/jpg"];
        }
        
    } andProgress:^(double progress) {
        
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
        }else{
            [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
        
    }];
}

@end
