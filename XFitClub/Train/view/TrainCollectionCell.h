//
//  TrainCollectionCell.h
//  XFitClub
//
//  Created by 郭炜 on 2017/4/19.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#define pTranItemDefaultHeight 200.0
#define pTranItemDefaultWidth 140.0
#define pStableXoffset screenwidth/2//item被放到最大的时候中心线x方向偏移量

@interface TrainCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

/**
 这个方法是调整item子视图的拉伸缩放，无需主动调用
 **/
-(void)transformSubViewsWithFrame:(CGRect)frame;
@end
