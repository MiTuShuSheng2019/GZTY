//
//  TYOutboundGoodsView.m
//  美界联盟
//
//  Created by LY on 2017/11/11.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYOutboundGoodsView.h"
#import "TYOutboundModel.h"
#import "TYOutboundCell.h"

@interface TYOutboundGoodsView ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 数据数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation TYOutboundGoodsView

+(instancetype)CreatTYOutboundGoodsView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
    [self addGestureRecognizer:tap];
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
}
//点击非弹框区域去取消
-(void)cancelView{
    [self removeFromSuperview];
}

- (IBAction)determine {
    [self removeFromSuperview];
}

-(void)setOutletNumber:(NSString *)OutletNumber{
    _OutletNumber = OutletNumber;
    [self requestOutDataSummary];
}



#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYOutboundCell *cell = [TYOutboundCell CellTableView:self.myTableView];
    cell.model = self.dataArr[indexPath.row];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}


#pragma mark -- 网络请求
//28 经销中心-发货管理-发货-根据出库流水号获取出库汇总信息
-(void)requestOutDataSummary{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = self.OutletNumber;//出库流水号
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/OutDataSummary",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYOutboundModel mj_objectArrayWithKeyValuesArray:[respondObject objectForKey:@"c"]];
            [self.dataArr addObjectsFromArray:arr];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}

- (NSMutableArray *) dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
