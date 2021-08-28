//
//  TYSimpeView.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYSimpeView.h"
#import "TYLowerGradeModel.h"
#import "TYChooseSharePlatformView.h"
#import "TYShareQrCodeView.h"

@interface TYSimpeView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 数据数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/** 分享链接 */
@property (nonatomic, strong) NSString *shareLink;

@end

@implementation TYSimpeView

+(instancetype)CreatTYSimpeView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    _myTableView.tableFooterView = [UIView new];
    _myTableView.showsVerticalScrollIndicator = NO;
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    //网络请求
    [self requestGetLowerGrade];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleView)];
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


- (IBAction)cancleButtonAction:(id)sender {
    [self cancleView];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    TYLowerGradeModel *model = self.dataArr[indexPath.row];
    [cell.textLabel setText:model.lName];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self removeFromSuperview];
    TYLowerGradeModel *model = self.dataArr[indexPath.row];
    [self requestGetLink:model.lId];
}

-(void) cancleView{
    [self removeFromSuperview];
}

#pragma mark -- 网络请求
//9 经销中心-授权中心-获取下级等级
-(void)requestGetLowerGrade{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"CusID"] = @([TYLoginModel getPrimaryId]);//分销商ID
    
//    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/getLowerGrade",APP_REQUEST_URL];
    NSString *url = [NSString stringWithFormat:@"%@SAPI/User/RegisteredCusGrade",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"Status"] boolValue] == true) {
            
            NSArray *arr = [TYLowerGradeModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"Data"] objectForKey:@"list"]];
            [self.dataArr addObjectsFromArray:arr];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"Msg"]];
        }
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        [TYShowHud showHudErrorWithStatus:@"接口请求失败"];
    }];
}

//11 经销中心-授权中心-生成分享链接
-(void)requestGetLink:(NSInteger)gradeId{
    
    [LoadManager showLoadingView:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(gradeId);//等级ID
    params[@"c"] = @([TYLoginModel getPrimaryId]);//用户ID
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/getLink",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
           self.shareLink = [[respondObject objectForKey:@"c"] objectForKey:@"d"];
            
            if (self.type == 1) {
                TYShareQrCodeView *QrCodeView = [TYShareQrCodeView CreatTYShareQrCodeView];
                QrCodeView.shareLink = self.shareLink;
                CreateCode *create = [[CreateCode alloc] init];
                create.url = self.shareLink;
                QrCodeView.qrImageView.image = [UIImage createNonInterpolatedUIImageFormCIImage:[create createGeneralCode] withSize:QrCodeView.qrImageView.frame.size.width];
                QrCodeView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:QrCodeView];
            }else{
                TYChooseSharePlatformView *shareView = [TYChooseSharePlatformView CreatTYChooseSharePlatformView];
                shareView.shareLink = self.shareLink;
                shareView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:shareView];
            }
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
         [LoadManager hiddenLoadView];
    }];
}


#pragma mark -- 懒加载
- (NSMutableArray *) dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
