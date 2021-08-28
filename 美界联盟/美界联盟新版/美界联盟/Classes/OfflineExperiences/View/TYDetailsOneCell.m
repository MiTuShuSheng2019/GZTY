//
//  TYDetailsOneCell.m
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDetailsOneCell.h"

@interface TYDetailsOneCell ()


@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;


@end

@implementation TYDetailsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYDetailsOneCell";
    TYDetailsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
    }
    return cell;
}

-(void)setDetailModel:(TYExpCenterDetailModel *)detailModel{
    _detailModel = detailModel;
    self.serviceLabel.text = [TYValidate IsNotNull:detailModel.g];
}

-(void)setServiceModel:(TYServiceModel *)serviceModel{
    _serviceModel = serviceModel;
    self.serviceLabel.text = [NSString stringWithFormat:@"服务项目：%@",serviceModel.sb];
}
@end
