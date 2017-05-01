//
//  TrainCollectionCell.m
//  XFitClub
//
//  Created by 郭炜 on 2017/4/19.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "TrainCollectionCell.h"
#define pNormalScale 0.8//最小的缩放比例
#define pMaxScale 1.0//最大的拉伸比例

@implementation TrainCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}

-(void)transformSubViewsWithFrame:(CGRect)frame
{
    CGFloat preferXoffset = pStableXoffset;//距离collectionView左边间距为此值时视图恢复正常大小
    
    CGFloat itemGaps = 0.0;//item的间距
    
    CGFloat itemXoffset = frame.origin.x;
    
    CGFloat animationMinOffset = -(frame.size.width - (preferXoffset-frame.size.width/2-itemGaps));//item子视图开始动画的最小x偏移量
    
    CGFloat animationMaxOffset = preferXoffset + frame.size.width/2 + itemGaps;//item子视图开始动画的最大x偏移量
    
    CGFloat normalOffset = preferXoffset - frame.size.width/2;//item子视图为1倍大小时的x方向偏移量
    
    CGFloat needScale = 0;
    
    if (itemXoffset > animationMinOffset && itemXoffset < animationMaxOffset) {
        
        if (itemXoffset<normalOffset) {//开始缩小
            
            CGFloat config = normalOffset - animationMinOffset;
            
            needScale =(itemXoffset-animationMinOffset)/config*(pMaxScale-pNormalScale)+pNormalScale;
            
        }else if (itemXoffset>normalOffset){//开始缩小
            
            CGFloat config = animationMaxOffset - normalOffset;
            
            needScale =(animationMaxOffset-itemXoffset)/config*(pMaxScale-pNormalScale)+pNormalScale;
            
        }else{//恢复正常(最大)
            
            needScale = pMaxScale;
            
        }
        
    }else{
        
        needScale = pNormalScale;
        
    }
    
    self.transform = CGAffineTransformMakeScale(needScale,needScale);
    
    CGRect subViewframe = self.frame;
    
    CGFloat bottomGaps = 8.0;
    
    subViewframe.origin.y = pTranItemDefaultHeight-subViewframe.size.height-bottomGaps;
    
    self.frame=subViewframe;
    
}
@end
