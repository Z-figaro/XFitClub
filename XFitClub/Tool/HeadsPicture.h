//
//  HeadsPicture.h
//  XFitClub
//
//  Created by figaro on 2017/4/25.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HeadsPicture : NSObject

+(instancetype)sharedHeadsPicture;
/**
 *  设置头像
 *
 *  @param image 图片
 */
-(void)setImage:(UIImage *)image forKey:(NSString *)key;

/**
 *  读取图片
 *
 */
-(UIImage *)imageForKey:(NSString *)key;

@end
