//
//  TYOutboundGoodsCell.m
//  美界联盟
//
//  Created by LY on 2017/11/10.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYOutboundGoodsCell.h"

@interface TYOutboundGoodsCell ()
//产品名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//条形码
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@end

@implementation TYOutboundGoodsCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYOutboundGoodsCell";
    TYOutboundGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYOutboundGoodsModel *)model{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"产品名称：%@",model.ec];
    self.codeLabel.text = [NSString stringWithFormat:@"条码：%@",model.eb];
}

-(void)setCheckModel:(TYTYCheckBarCodeBigModel *)checkModel{
    _checkModel = checkModel;
    TYCheckBarCodeModel *model = [checkModel.f firstObject];
    self.nameLabel.text = [NSString stringWithFormat:@"产品名称：%@",model.fl];
    if (checkModel.d == 1) {
        self.codeLabel.text = [NSString stringWithFormat:@"条码：%@",model.fb];
    }else if (checkModel.d == 2){
        self.codeLabel.text = [NSString stringWithFormat:@"条码：%@",model.fc];
    }else{
        self.codeLabel.text = [NSString stringWithFormat:@"条码：%@",model.fd];
    }
    
}

@end
