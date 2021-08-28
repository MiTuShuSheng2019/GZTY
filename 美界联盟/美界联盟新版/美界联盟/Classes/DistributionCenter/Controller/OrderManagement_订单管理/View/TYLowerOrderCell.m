//
//  TYLowerOrderCell.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLowerOrderCell.h"

@interface TYLowerOrderCell ()
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//总计
@property (weak, nonatomic) IBOutlet UILabel *totleLabel;

@end



@implementation TYLowerOrderCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYLowerOrderCell";
    TYLowerOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detalBtn.layer.borderColor = RGB(236, 236, 236).CGColor;
    self.auditBtn.layer.borderColor = RGB(236, 236, 236).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYMyOrderModel *)model{
    _model = model;
    
    self.nameLabel.text = [NSString stringWithFormat:@"名字：%@",model.eg];
    self.telLabel.text = [NSString stringWithFormat:@"电话：%@",model.ei];
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",model.eh];
    self.stateLabel.text = [NSString stringWithFormat:@"状态:%@",model.ef];
    self.totleLabel.text = [NSString stringWithFormat:@"共%ld件商品，共计￥%@",model.ed,model.ec];
    
}

//审核通过
- (IBAction)ClickAuditApproval:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(AuditApproval:)]) {
        [_delegate AuditApproval:sender];
    }
    
}

//查看详情
- (IBAction)ClickLookDetal:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(LookDetail:)]) {
        [_delegate LookDetail:sender];
    }
    
}


@end
