//
//  TYConsumerPersonSetVC.m
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYConsumerPersonSetVC.h"
#import "TYChangePasswordViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TYConsumerPersonSetVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *telField;

@end

@implementation TYConsumerPersonSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"个人设置" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoUrl,[TYConsumerLoginModel getPhoto]]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameField.text = [TYConsumerLoginModel getUserName];
    self.telField.text = [TYConsumerLoginModel getTelephone];//电话号码
    self.nameField.enabled = NO;
    self.telField.enabled = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark -- 点击修改头像
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
    //    NSLog(@"保存头像！");
    self.headImageView.image = image;
    
    [self requestPhoto:image];
}

#pragma mark -- 点击登录密码
- (IBAction)ClickLoginPassWord {
    [self.view endEditing:YES];
    TYChangePasswordViewController *viewController =
    [[TYChangePasswordViewController alloc] init];
    viewController.type = 1;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -- 点击保存
- (IBAction)ClickSave {
    [self.view endEditing:YES];
    [TYShowHud showHudSucceedWithStatus:@"修改成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 网络请求
//更新头像
-(void)requestPhoto:(UIImage *)image{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"a"] = [TYConsumerLoginModel getSessionID];//sessionID
    dic[@"b"] = [TYConsumerLoginModel getPrimaryId];//用户ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/SM/UpdateMemberInfo",APP_REQUEST_URL];
    [TYNetworking postFileDataWithUrl:url parameters:dic andconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@_%@_head.jpg",@"1",[TYNetworking timeStampeWithRandom]] mimeType:@"image/jpg"];
        
    } andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        [TYShowHud showHudSucceedWithStatus:@"修改成功"];
        [TYConsumerLoginModel savePhoto:[respondObject objectForKey:@"c"]];
    } orFailBlock:^(id error) {
        
    }];
}

@end
