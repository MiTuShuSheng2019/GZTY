//
//  TYDeliveryManagermentDetailsVC.m
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDeliveryManagermentDetailsVC.h"

@interface TYDeliveryManagermentDetailsVC ()

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *inCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *outCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailBackCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailLabel;


@end

@implementation TYDeliveryManagermentDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"库存明细" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.model.f];
    
     self.inCountLabel.text = [NSString stringWithFormat:@"进货总数量：%ld",self.model.e];
    
     self.outCountLabel.text = [NSString stringWithFormat:@"出库总数量：%ld",self.model.d];
    
     self.retailBackCountLabel.text = [NSString stringWithFormat:@"售退零售数量：%ld",self.model.h];
    
     self.backLabel.text = [NSString stringWithFormat:@"售退数量：%ld",self.model.i];
    
     self.returnTopLabel.text = [NSString stringWithFormat:@"退货数量：%ld",self.model.g];
    
     self.retailLabel.text = [NSString stringWithFormat:@"零售数量：%ld",self.model.k];
}



@end
