//
//  TrainCell.m
//  XFitClub
//
//  Created by 郭炜 on 2017/4/19.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "TrainCell.h"
#import "Header.h"

@implementation TrainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = [RGBCOLOR(204, 204, 204, 1)  colorWithAlphaComponent:0.6].CGColor;
    self.backView.layer.borderWidth = 0.5f;
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
