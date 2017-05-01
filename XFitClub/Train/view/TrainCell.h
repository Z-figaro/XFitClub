//
//  TrainCell.h
//  XFitClub
//
//  Created by 郭炜 on 2017/4/19.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *trainImage;
@property (weak, nonatomic) IBOutlet UILabel *name;


@end
