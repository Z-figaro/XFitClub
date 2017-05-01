//
//  challengeTableViewCell.h
//  XFitClub
//
//  Created by figaro on 2017/4/27.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface challengeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UIImageView *sportsImage;
@property (weak, nonatomic) IBOutlet UILabel *sportsNumber;
@property (weak, nonatomic) IBOutlet UILabel *sportsName;

+(instancetype) cellWithTableView:(UITableView *)tableview;
@end
