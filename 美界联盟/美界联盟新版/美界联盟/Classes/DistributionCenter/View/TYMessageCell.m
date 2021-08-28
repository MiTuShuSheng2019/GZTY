//
//  TYMessageCell.m
//  美界联盟
//
//  Created by LY on 2017/10/26.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMessageCell.h"

@interface TYMessageCell ()
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TYMessageCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYMessageCell";
    TYMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];    }
    return cell;
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYManageModel *)model{
    _model = model;
    self.contentLabel.text = model.eb;
    self.timeLabel.text = model.ed;
    
    if (model.ee == 3) {
       //1：未读；3：已读；
        self.contentLabel.textColor  = [UIColor lightGrayColor];
        self.timeLabel.textColor  = [UIColor lightGrayColor];
        
    }else{
        self.contentLabel.textColor  = [UIColor blackColor];
         self.timeLabel.textColor  = [UIColor blackColor];
    }
}

@end
