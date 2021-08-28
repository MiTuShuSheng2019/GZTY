//
//  TYPersonSetViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYPersonSetViewController.h"
#import "TYChangePasswordViewController.h"

@interface TYPersonSetViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImagView;
//微信
@property (weak, nonatomic) IBOutlet UITextField *weixinTextField;
//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//电话
@property (weak, nonatomic) IBOutlet UITextField *telTextField;

@end

@implementation TYPersonSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"个人设置" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnText:@"保存" andTextColor:[UIColor whiteColor]];
    
    //添加默认值
    [self.headImagView setHead:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getPhoto]]];
    self.weixinTextField.text = [TYValidate IsNotNull:[TYLoginModel getWeiXing]];
    self.nameTextField.text = [TYValidate IsNotNull:[TYLoginModel getUserName]];
    self.telTextField.text = [TYValidate IsNotNull:[TYLoginModel getPhone]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -- 保存
- (void)navigationRightBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    [SVProgressHUD showSuccessWithStatus:@"等待开发"];
    [SVProgressHUD dismissWithDelay:1.0];
    
}

#pragma mark -- 修改头像
- (IBAction)ClickRevampHeadImage {
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选图片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"本地相册",nil];
    [actionSheet showInView:self.view];
}

#pragma mark -- UIActionSheet Delegate(添加头像)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 1://相册
        {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.navigationBar.translucent = TRUE;
            imagePicker.navigationBar.barTintColor = RGB(32, 135, 238);
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //更改titieView的字体颜色
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
            [imagePicker.navigationBar setTitleTextAttributes:attrs];
            [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attrs forState:UIControlStateNormal];
            //更改返回照片返回按钮的颜色
            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark --拍摄完成 UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
//        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        //        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
   
    self.headImagView.image = image;
    [self requestPhoto:image];
}


#pragma mark -- 登录密码管理
- (IBAction)ClickLoginPassword {
    [self.view endEditing:YES];
    TYChangePasswordViewController *passwordVc = [[TYChangePasswordViewController alloc] init];
    passwordVc.type = 1;
    [self.navigationController pushViewController:passwordVc animated:YES];
}

#pragma mark -- 交易密码管理
- (IBAction)ClickTradePassword {
    [self.view endEditing:YES];
    TYChangePasswordViewController *passwordVc = [[TYChangePasswordViewController alloc] init];
    passwordVc.type = 2;
    [self.navigationController pushViewController:passwordVc animated:YES];
}

#pragma mark -- 地址管理
- (IBAction)ClickAddressManagement {
    [self.view endEditing:YES];
}

#pragma mark -- 退出登录
- (IBAction)ClickLogOut {
    
}

#pragma mark -- 网络请求
//更新头像
-(void)requestPhoto:(UIImage *)image{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"a"] = [TYLoginModel getSessionID];//sessionID
    dic[@"b"] = @([TYLoginModel getPrimaryId]);//用户ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/SM/UpdateMemberInfo",APP_REQUEST_URL];
    [TYNetworking postFileDataWithUrl:url parameters:dic andconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@_%@_head.jpg",@"1",[TYNetworking timeStampeWithRandom]] mimeType:@"image/jpg"];
        
    } andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        [SVProgressHUD showSuccessWithStatus:[respondObject objectForKey:@"b"]];
        [SVProgressHUD dismissWithDelay:1];
        //图片保存到本地
        [self saveImage:self.headImagView.image WithName:[NSString stringWithFormat:@"selfPhoto.jpg"]];
    } orFailBlock:^(id error) {
        
    }];
    
}

#pragma mark - 保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSString * pathString = [NSString stringWithFormat:@"Documents/%@",imageName];
    //设置照片的品质
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    
    NSLog(@"%@",NSHomeDirectory());
    // 获取沙盒目录
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:pathString];
    // 将图片写入文件
    [imageData writeToFile:filePath atomically:NO];
    //将选择的图片显示出来
//        [self.headImagView setImage:[UIImage imageWithContentsOfFile:filePath]];
    
}

@end
