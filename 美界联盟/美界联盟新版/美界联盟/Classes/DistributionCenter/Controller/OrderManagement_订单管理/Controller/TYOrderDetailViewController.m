//
//  TYOrderDetailViewController.m
//  美界app
//
//  Created by LY on 2017/10/21.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYOrderDetailViewController.h"
#import "TYOrderDetailsTableViewCell.h"

@interface TYOrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//头部视图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@end

@implementation TYOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"订单详情" andTitleColor:[UIColor whiteColor] andImage:nil];
    
     NSString *address = nil;
    
    if ([TYSingleton shareSingleton].consumer == 1) {
        self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",self.consumerModel.di];
        self.addressLabel.text = [NSString stringWithFormat:@"收货地址:%@",self.consumerModel.dj];
        address = [NSString stringWithFormat:@"收货地址:%@",[TYValidate IsNotNull:self.consumerModel.dj]];
        self.telLabel.text = [NSString stringWithFormat:@"电话:%@",self.consumerModel.dk];
        self.orderLabel.text = [NSString stringWithFormat:@"订单号: %@",self.consumerModel.db];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",self.model.eg];
        self.addressLabel.text = [NSString stringWithFormat:@"收货地址:%@",self.model.eh];
        address = [NSString stringWithFormat:@"收货地址:%@",[TYValidate IsNotNull:self.model.eh]];
        self.telLabel.text = [NSString stringWithFormat:@"电话:%@",self.model.ei];
        self.orderLabel.text = [NSString stringWithFormat:@"订单号: %@",self.model.eb];
    }
    
   
    // 计算文字的高度
    CGSize rec = [address boundingRectWithSize:CGSizeMake(KScreenWidth - 55, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
    self.topViewH.constant = 45 + rec.height + 5 + 45;
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}


#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([TYSingleton shareSingleton].consumer == 1) {
        return self.consumerModel.de.count;
    }else{
        return self.model.ek.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYOrderDetailsTableViewCell *cell = [TYOrderDetailsTableViewCell CellTableView:self.myTableView];
    if ([TYSingleton shareSingleton].consumer == 1) {
         cell.consumerModel = self.consumerModel.de[indexPath.row];
    }else{
         cell.model = self.model.ek[indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

@end
