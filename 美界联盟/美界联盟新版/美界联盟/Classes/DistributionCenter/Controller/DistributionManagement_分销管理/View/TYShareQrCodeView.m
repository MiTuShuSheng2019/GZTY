//
//  TYShareQrCodeView.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShareQrCodeView.h"
#import "TYChooseSharePlatformView.h"

@interface TYShareQrCodeView()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *certerHeadImageView;
@end

@implementation TYShareQrCodeView

+(instancetype)CreatTYShareQrCodeView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.5];
   
    //赋值头像和姓名
    [self.headImageView setHead:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getPhoto]]];
    self.nameLabel.text = [TYLoginModel getUserName];
    [self.certerHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getPhoto]]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];

}

#pragma mark -- <UIGestureRecognizerDelegate>
//实现此代理是为了防止点击弹框区域视图也消失
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.backView]) {
        return NO;
    }
    return YES;
}

//点击非弹框区域去取消
-(void)cancelView{
    [self removeFromSuperview];
}

//分享
- (IBAction)share {
    [self removeFromSuperview];
    TYChooseSharePlatformView *shareView = [TYChooseSharePlatformView CreatTYChooseSharePlatformView];
    shareView.shareLink = self.shareLink;
    shareView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareView];
}

//保存
- (IBAction)save:(id)sender {
    [self removeFromSuperview];
    //图片保存到本地
    [self saveImageToPhotos:self.qrImageView.image];
}

//实现该方法保存图片
- (void)saveImageToPhotos:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [SVProgressHUD showWithStatus:msg];
    [SVProgressHUD dismissWithDelay:1.0];
    [self removeFromSuperview];
}

#pragma mark - 保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSString * pathString = [NSString stringWithFormat:@"Documents/%@",imageName];
    //设置照片的品质
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    
    // 获取沙盒目录
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:pathString];
    // 将图片写入文件
    [imageData writeToFile:filePath atomically:NO];
    //将选择的图片显示出来
}
@end
