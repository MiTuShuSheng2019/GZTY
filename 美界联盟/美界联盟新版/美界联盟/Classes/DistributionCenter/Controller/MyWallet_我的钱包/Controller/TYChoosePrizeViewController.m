//
//  TYChoosePrizeViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYChoosePrizeViewController.h"
#import "TYLuxuryCarCell.h"
#import "TYChoosePrizeCell.h"

@interface TYChoosePrizeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation TYChoosePrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"选择奖品" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark --  <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TYLuxuryCarCell *cell = [TYLuxuryCarCell CellTableView:self.myTableView];
        cell.DetailModel = self.model;
        return cell;
    }else {
        TYChoosePrizeCell *cell = [TYChoosePrizeCell CellTableView:self.myTableView];
        cell.model = self.model;;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        return 60 + 10 + (KScreenWidth * 9 /25);
        //图片比例25：9  后期可根据需求调整
    }else{
       
        return self.model.ChoosePrizeCellH;
    }
}


@end
