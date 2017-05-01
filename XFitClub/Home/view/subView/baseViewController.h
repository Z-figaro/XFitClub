//
//  baseViewController.h
//  XFitClub
//
//  Created by figaro on 2017/4/20.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumAction;
@property (weak, nonatomic) IBOutlet UILabel *trainNumber;
@property (weak, nonatomic) IBOutlet UILabel *challengeNumber;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UILabel *cariolNumber;

@end
