//
//  ZPPAccountTool.m
//  XFitClub
//
//  Created by figaro on 2017/3/20.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "ZPPAccountTool.h"
#import "ZPPUserDefaults.h"

@implementation ZPPAccountTool

#pragma mark - 用户账户的信息
+(ZPPAccountTool *)sharedUserOBJ{
    static dispatch_once_t onceToken;
    static ZPPAccountTool *sharedUserOBJ = nil;
    dispatch_once(&onceToken,^{
        sharedUserOBJ = [[ZPPAccountTool alloc] init];
    });
    return sharedUserOBJ;
}

/**
 设定用户名称

 */
-(void)setUserName:(NSString *)userName{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userName forKey:ZPP_userName];
}

/**
 设定用户密码

 */
-(void)setPwd:(NSString *)pwd{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:pwd forKey:ZPP_userPassWord];
}

/**
 设定用户账户ID
 */
- (void)setUserID:(NSString *)userID{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userID forKey:ZPP_userID];
}

/**
 设定用户token
 */
- (void)setUserToken:(NSString *)userToken{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userToken forKey:ZPP_userToken];
}

/**
 设定用户头像
 */
- (void)setUserAvatar:(NSString *)userAvatar{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userAvatar forKey:ZPP_userAvatar];
}
/**
 保存用户身高
 */
- (void)setUserHeight:(NSString *)userHeight{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userHeight forKey:ZPP_userHeight];
}
/**
 保存用户体重
 */
-(void)setUserWeight:(NSString *)userWeight{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userWeight forKey:ZPP_userWeight];
}
/**
 保存用户生日
 */
-(void)setUserBrithday:(NSString *)userBrithday{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userBrithday forKey:ZPP_userBrithday];
}
/**
 保存用户性别
 */
-(void)setUserSex:(NSString *)userSex{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userSex forKey:ZPP_userSex];
}
/**
 保存用户验证码
 */
-(void)setUserVerificationCode:(NSString *)userVerificationCode{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userVerificationCode forKey:ZPP_userVerificationCode];
}
/**
 保存用户登录情况
 */
-(void)setUserLogin:(NSString *)userLogin{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userLogin forKey:ZPP_userLogin];
}
/**
 保存用户memberID
 */
-(void)setUserMemberID:(NSString *)userMemberID{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault setObject:userMemberID forKey:ZPP_userMemberID];
}

#pragma mark - 得到用户信息
/**
 得到用户memberID
 */
-(NSString*)getUserMemberID{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userMemberID];
}
/**
 得到用户登录情况
 */
-(NSString*)getUserLogin{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userLogin];
}
/**
 得到用户名称
 */
-(NSString*)getUserName{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userName];
}
/**
 得到用户密码
 */
-(NSString*)getPassWord{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userPassWord];
}

/**
 得到用户账户ID
 */
- (NSString*)getUserID{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userID];
}

/**
 得到用户token
 */
- (NSString*)getToken{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userToken];
}
/**
 保存用户头像
 */
- (NSString*)getUserAvatar{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userAvatar];
}
/**
 保存用户身高
 */
- (NSString*)getUserHeight{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userHeight];
}
/**
 保存用户体重
 */
- (NSString*)getUserWeight{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userWeight];
}
/**
 保存用户生日
 */
- (NSString*)getUserBrithday{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userBrithday];
}
/**
 保存用户性别
 */
- (NSString*)getUserSex{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userSex];
}
/**
 保存用户验证码
 */
- (NSString*)getUserVerificationCode{
    ZPPUserDefaults *userDefault = [ZPPUserDefaults sharedWXUserDefault];
    return [userDefault textValueForKey:ZPP_userVerificationCode];
}

/**
 移除所有用户数据
 */
- (void)removeAllUserInfo{
    ZPPUserDefaults*userDefault = [ZPPUserDefaults sharedWXUserDefault];
    [userDefault removeObjectForKey:ZPP_userID];
    [userDefault removeObjectForKey:ZPP_userToken];
    [userDefault removeObjectForKey:ZPP_userName];
    [userDefault removeObjectForKey:ZPP_userPassWord];
    [userDefault removeObjectForKey:ZPP_userLogin];
    [userDefault removeObjectForKey:ZPP_userMemberID];
    [userDefault removeObjectForKey:ZPP_userSex];
    [userDefault removeObjectForKey:ZPP_userAvatar];
    [userDefault removeObjectForKey:ZPP_userHeight];
    [userDefault removeObjectForKey:ZPP_userWeight];
    [userDefault removeObjectForKey:ZPP_userBrithday];
    [userDefault removeObjectForKey:ZPP_userVerificationCode];
//    [userDefault removeObjectForKey:zpp];
    
}


#pragma mark - 简单写法
/**
 *  缓存写入
 */
+ (void)putUserDefaults:(NSString *)value key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  缓存读取
 */
+ (NSString *)getUserDefaults:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
/**
 *  缓存清除
 */
+ (void)clearUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
