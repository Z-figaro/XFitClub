//
//  TableViewCell.h
//  XFitClub
//
//  Created by 张鹏 on 2017/4/19.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeData;
@property (weak, nonatomic) IBOutlet UILabel *useTime;
@property (weak, nonatomic) IBOutlet UILabel *actionName;
@property (weak, nonatomic) IBOutlet UILabel *actionScore;

+ (instancetype) xibTableViewCell;
@end
