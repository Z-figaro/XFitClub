//
//  challengeTableViewCell.m
//  XFitClub
//
//  Created by figaro on 2017/4/27.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "challengeTableViewCell.h"

@implementation challengeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype) cellWithTableView:(UITableView *)tableview{
    
    static NSString *identifier = @"challengeCell";
    challengeTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
    }
    
    return cell;
}
@end
