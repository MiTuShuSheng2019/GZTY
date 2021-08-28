//
//  TYPersonSetViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYPersonSetViewController.h"
#import "TYChangePasswordViewController.h"
#import "TYLoginChooseViewController.h"
#import "TYAddressManagementVC.h"
#import <AVFoundation/AVFoundation.h>
#import "TYDistributorsAddressManagementVC.h"

@interface TYPersonSetViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImagView;
//微信
@property (weak, nonatomic) IBOutlet UITextField *weixinTextField;
//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//电话
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
//银行卡号
@property (weak, nonatomic) IBOutlet UITextField *bankTextField;

@end

@implementation TYPersonSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"个人设置" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnText:@"保存" andTextColor:[UIColor whiteColor]];
    
    self.headImagView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImagView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.headImagView.clipsToBounds = YES;
    //添加默认值
    [self.headImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getPhoto]]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.weixinTextField.text = [TYValidate IsNotNull:[TYLoginModel getWeiXing]];
    self.nameTextField.text = [TYValidate IsNotNull:[TYLoginModel getUserName]];
    self.telTextField.text = [TYValidate IsNotNull:[TYLoginModel getPhone]];
    self.bankTextField.text = [TYValidate IsNotNull:[TYLoginModel getBankCardNumber]];
    
    self.nameTextField.enabled = NO;
    self.telTextField.enabled = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -- 保存
- (void)navigationRightBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    
    [self requestUpdatecus];
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
            NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                //用户关闭了相机权限
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"应用相机权限受限,请在设置中启用" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 无权限 引导去开启
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                
                [alertVc addAction:action1];
                [alertVc addAction:action2];
                [self presentViewController:alertVc animated:YES completion:nil];
                
                return;
            }
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
    
    TYAddressManagementVC *AddVc = [[TYAddressManagementVC alloc] init];
    [self.navigationController pushViewController:AddVc animated:YES];
}

#pragma mark -- 分销商地址管理
- (IBAction)DistributorsAddressManagement {
     [self.view endEditing:YES];
    TYDistributorsAddressManagementVC *vc = [[TYDistributorsAddressManagementVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 退出登录
- (IBAction)ClickLogOut {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出登陆吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [TYLoginModel cleanUserLoginAllMessage];
      
        [self.navigationController pushViewController:[[TYLoginChooseViewController alloc] init] animated:YES];
    }];
    
    [alertVc addAction:action1];
    [alertVc addAction:action2];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark -- 网络请求
//88 经销中心 修改头像
-(void)requestPhoto:(UIImage *)image{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"a"] = [TYLoginModel getSessionID];//sessionID
    dic[@"b"] = @([TYLoginModel getPrimaryId]);//用户ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/MCus/UploadDisPic",APP_REQUEST_URL];
    [TYNetworking postFileDataWithUrl:url parameters:dic andconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",[TYNetworking timeStampeWithRandom]] mimeType:@"image/jpg"];
        
    } andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
        
        [TYLoginModel savePhoto:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
//        //图片保存到本地
//        [self saveImage:self.headImagView.image WithName:[NSString stringWithFormat:@"selfPhoto.jpg"]];
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

//【8 经销中心-用户管理-修改编辑个人信息】
-(void)requestUpdatecus{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"a"] = [TYLoginModel getSessionID];//sessionID
    dic[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID

    dic[@"d"] = self.nameTextField.text;//姓名
    dic[@"e"] = self.telTextField.text;//电话
    dic[@"f"] = self.weixinTextField.text;//微信号
    dic[@"g"] = [TYLoginModel getAPPID];//设备ID
    dic[@"h"] = self.bankTextField.text;//银行卡号
  
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/updatecus",APP_REQUEST_URL];
    
    [TYNetworking postRequestURL:url parameters:dic andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [TYLoginModel saveName:self.nameTextField.text];
            [TYLoginModel savePhone:self.telTextField.text];
            [TYLoginModel saveWeixin:self.weixinTextField.text];
            [TYLoginModel saveBankCardNumber:self.bankTextField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
        
    }];
}

@end
