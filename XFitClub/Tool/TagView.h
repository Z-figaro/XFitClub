//
//  TypeView.h
//  SingaporeBusiness
//
//  Created by Mike on 16/6/7.
//  Copyright © 2016年 Julian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagViewDelegate <NSObject>

-(void)tagClicked:(NSString *)tag;

@end

@interface TagView : UIView


@property (nonatomic, weak) id<TagViewDelegate> delegate;

@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) NSArray<NSString *> *types;
///标签颜色
@property (nonatomic, strong) UIColor *titleColor;
///边框颜色
@property (nonatomic, strong) UIColor *borderColor;
///标签字体
@property (nonatomic, assign) NSInteger textFont;

@end
