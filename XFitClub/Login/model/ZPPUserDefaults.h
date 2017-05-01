//
//  ZPPUserDefaults.h
//  XFitClub
//
//  Created by figaro on 2017/3/28.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZPPUserDefaultsDefine.h"

@interface ZPPUserDefaults : NSObject
+ (id)sharedWXUserDefault;

- (NSInteger)integerValueForKey:(NSString*)key;
- (BOOL)boolValueForKey:(NSString*)key;
- (NSString*)textValueForKey:(NSString*)key;
- (NSDictionary*)dicValueForKey:(NSString*)key;
- (CGFloat)floatValueForKey:(NSString*)key;

- (void)setInteger:(NSInteger)value forKey:(NSString*)key;
- (void)setBool:(BOOL)value forKey:(NSString*)key;
- (void)setFloat:(float)value forkey:(NSString*)key;
- (void)setObject:(id)object forKey:(NSString*)key;

- (void)removeObjectForKey:(NSString*)key;
- (NSArray*)allKeys;
- (BOOL)hasKey:(NSString*)key;

@end
