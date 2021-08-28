//
//  TYContactUsViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYContactUsViewController.h"
#import "TYContactUsCell.h"

@interface TYContactUsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;

/** TYContactUsModel */
@property (nonatomic, strong) TYContactUsModel *model;

@end

@implementation TYContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"联系我们" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.titleArr = [NSArray arrayWithObjects:@"部门：", @"座机：", @"手机：", @"传真：", @"邮件：", @"联系地址：", nil];
    [self setUpTableView];
}

//初始化TableView
-(void)setUpTableView{
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    //网络请求
    [self requestContactus];
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYContactUsCell *cell = [TYContactUsCell CellTableView:self.myTableView];
    cell.title.text = self.titleArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.content.text = self.model.d;
    }else if (indexPath.row == 1){
        cell.content.text = self.model.e;
    }else if (indexPath.row == 2){
        cell.content.text = self.model.f;
    }else if (indexPath.row == 3){
        cell.content.text = self.model.g;
    }else if (indexPath.row == 4){
        cell.content.text = self.model.h;
    }else if (indexPath.row == 5){
        cell.content.text = self.model.i;
    }
    return cell;
}


#pragma mark --- 网络请求
//获取历史记录
-(void)requestContactus{
    [LoadManager showLoadingView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/msys/contactus",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            self.model = [TYContactUsModel mj_objectWithKeyValues:[respondObject objectForKey:@"c"]];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

@end
