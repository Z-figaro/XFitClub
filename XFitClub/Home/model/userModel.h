//
//  userModel.h
//  XFitClub
//
//  Created by 张鹏 on 2017/4/16.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userModel : NSObject
+(userModel *)sharedUserOBJ;
@property (nonatomic, strong) NSString *userAvatarString;

@end
