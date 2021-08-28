//
//  TYNewLibraryInformationVC.m
//  美界联盟
//
//  Created by LY on 2017/11/13.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYNewLibraryInformationVC.h"
#import "TYQRCodeViewController.h"
#import "TYOutboundGoodsCell.h"
#import "TYTYCheckBarCodeBigModel.h"

@interface TYNewLibraryInformationVC ()

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation TYNewLibraryInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"商品出库" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    //接收通知传值
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];    [center addObserver:self selector:@selector(RefreshCodeTextFieldData:) name:@"backTYAuthorizationQueryViewController" object:nil];
}

-(void)RefreshCodeTextFieldData:(NSNotification *)not{
    self.codeTextField.text = [not.userInfo objectForKey:@"metadataObject"];
    [self requestCheckBarCode];
}

#pragma mark -- 点击扫描
- (IBAction)ClickScan {
    [self.view endEditing:YES];
    TYQRCodeViewController *qrVc = [[TYQRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrVc animated:YES];
}

#pragma mark -- 点击查询
- (IBAction)ClickEnquiries {
    if (self.codeTextField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"条码不能为空"];
        return;
    }
    [self.view endEditing:YES];
    [self requestCheckBarCode];
}

#pragma mark -- 确定出库
- (IBAction)ClickDetermineOutbound {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认出库吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (int i = 0; i < self.modelArray.count; ++i) {
            TYTYCheckBarCodeBigModel *bigModel = self.modelArray[i];
            TYCheckBarCodeModel *model = [bigModel.f firstObject];
            NSString *code = nil;
            //根据条码类型取出条码
            if (bigModel.d == 1) {
                code = model.fb;
            }else if (bigModel.d == 2){
                
                code = model.fc;
            }else{
                
                code = model.fd;
            }
            //拼接构成条码请求数据
            NSString *idStr = [NSString stringWithFormat:@"%@_%ld_%@",code,(long)bigModel.d,model.fk];
            [self requestConfirmOutStorage:idStr];
        }
        
    }];
    
    [alertVc addAction:action1];
    [alertVc addAction:action2];
    [self presentViewController:alertVc animated:YES completion:nil];
    [self.view endEditing:YES];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYOutboundGoodsCell *cell = [TYOutboundGoodsCell CellTableView:self.myTableView];
    cell.checkModel = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//修改左滑的按钮的字
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TYTYCheckBarCodeBigModel  *bigModel = self.modelArray[indexPath.row];
        TYCheckBarCodeModel *model = [bigModel.f firstObject];
        // 获取选中删除行索引值
        NSInteger row = [indexPath row];
        // 通过获取的索引值删除数组中的值
        [self.modelArray removeObjectAtIndex:row];
        // 删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self requestOutStorageDetailDeleted:model.fd];
    }
}

#pragma mark -- 网络请求
//39 经销中心-发货管理-条码状态检查
-(void)requestCheckBarCode{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = self.codeTextField.text;//条码
    
    NSString *url = [NSString stringWithFormat:@"%@/mapi/mpsi/CheckBarCode",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            TYTYCheckBarCodeBigModel *model = [TYTYCheckBarCodeBigModel mj_objectWithKeyValues:[respondObject objectForKey:@"c"]];
            [self.modelArray addObject:model];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
        
    } orFailBlock:^(id error) {
        
    }];
}

//【30 经销中心-发货管理-发货-预出库删除】
-(void)requestOutStorageDetailDeleted:(NSString *)code{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = code;//条码
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/OutStorageDetailDeleted",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [TYShowHud showHudSucceedWithStatus:@"删除成功"];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
    }];
}

//40 经销中心-发货管理-零售出库
-(void)requestConfirmOutStorage:(NSString *)codeStr{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = codeStr;//构造条码
    
    NSString *url = [NSString stringWithFormat:@"%@/mapi/mpsi/ConfirmOutStorage",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            [TYShowHud showHudSucceedWithStatus:@"出库成功"];
            [self.modelArray removeAllObjects];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
        
    } orFailBlock:^(id error) {
        
    }];
}

@end
