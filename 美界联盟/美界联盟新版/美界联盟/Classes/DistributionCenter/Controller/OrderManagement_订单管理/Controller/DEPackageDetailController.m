//
//  DEPackageDetailController.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/10/30.
//  Copyright © 2019 刘燚. All rights reserved.
//

#import "DEPackageDetailController.h"
#import "TYOrderDetailsTableViewCell.h"
#import "TYRetailOutStorageModel.h"
#import "TYConfirmOrderVC.h"

@interface DEPackageDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DEPackageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:self.model.ec andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.nameLabel.text = self.model.ec;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.ee];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,self.model.eb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    
    [self requestData];
    [self setTableVIew];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"套餐详情";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYOrderDetailsTableViewCell *cell = [TYOrderDetailsTableViewCell CellTableView:self.myTableView];
    
    TYRetailOutStorageModel *model = [[TYRetailOutStorageModel alloc]init];
    NSDictionary* info = [_dataArr objectAtIndex:indexPath.row];
    model.fn = [info objectForKey:@"PicUrl"];
    model.fm = [info objectForKey:@"Name"];
    model.fo = [[info objectForKey:@"CurrPrice"] doubleValue];
    model.fl = [[info objectForKey:@"ProdCount"] integerValue];
    cell.retailModel = model;
    return cell;
}

#pragma mark -- 设置tableviw
-(void) setTableVIew{
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -- shoppingButtonClick
-(IBAction)shoppingButtonClick:(id)sender
{
    self.model.countNumber = 1;
    
    TYConfirmOrderVC *orderVc = [[TYConfirmOrderVC alloc] init];
    orderVc.modelArray = [NSMutableArray arrayWithObjects:self.model, nil];
    orderVc.buyType = 2;
    [self.navigationController pushViewController:orderVc animated:YES];
}

#pragma mark -- 网络请求

-(void)requestData{
    [LoadManager showLoadingView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"PPId"] = [NSString stringWithFormat:@"%ld",self.model.ea];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mprod/ProdPackageDetail",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
//            NSArray *arr = [TYSelectProduct mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"ProdInfos"]];
            [self.dataArr addObjectsFromArray:[[respondObject objectForKey:@"c"] objectForKey:@"ProdInfos"]];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

-(NSMutableArray*)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
