//
//  TableViewCell.m
//  XFitClub
//
//  Created by 张鹏 on 2017/4/19.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)xibTableViewCell{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil] lastObject];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
