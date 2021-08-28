//
//  TYReservationDetailVC.m
//  美界联盟
//
//  Created by LY on 2017/11/29.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYReservationDetailVC.h"
#import "TYReservationCell.h"

@interface TYReservationDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation TYReservationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"预约详情" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark <UITableViewDelegate, UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.model.cellH;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYReservationCell *cell = [TYReservationCell CellTableView:self.myTableView];
    cell.detailModel = self.model;
    
    return cell;
}

@end
