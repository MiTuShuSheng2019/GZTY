//
//  TYCargoCell.m
//  美界联盟
//
//  Created by LY on 2017/12/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYCargoCell.h"

@interface TYCargoCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totleLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationSbel;


@end

@implementation TYCargoCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYCargoCell";
    TYCargoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYCargoModel *)model{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"产品名称：%@", [TYValidate IsNotNull:model.ProductFullName]];
    self.operationLabel.text = [NSString stringWithFormat:@"操作：%@", [TYValidate IsNotNull:model.OperateTitle]];
    self.shopNameLabel.text = [NSString stringWithFormat:@"收货人：%@", [TYValidate IsNotNull:model.DistributorFullName]];
    self.totleLabel.text = [NSString stringWithFormat:@"发货人：%@", [TYValidate IsNotNull:model.InDistributorFullName]];
    self.operationSbel.text = [NSString stringWithFormat:@"操作者：%@", [TYValidate IsNotNull:model.CreatorName]];
}

@end
