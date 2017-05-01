//
//  ZPPAccountTool.h
//  XFitClub
//
//  Created by figaro on 2017/3/20.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

/*
    account:用户登录时的账户信息
    Info：用户在APP中的个人信息
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define ShareUserModel [ZPPAccountTool sharedUserOBJ]
@interface ZPPAccountTool : NSObject

#pragma mark - 用户账户信息，工程更优秀写法

+(ZPPAccountTool *)sharedUserOBJ;

/**
 设定用户昵称
 */
-(void)setUserName:(NSString*)userName;
/**
 设定用户密码
 */
-(void)setPwd:(NSString*)pwd;
/**
 设定用户账户ID
 */
-(void)setUserID:(NSString*)userID;
/**
 设定用户token
 */
-(void)setUserToken:(NSString *)userToken;

/**
 保存用户头像
 */
-(void)setUserAvatar:(NSString *)userAvatar;
/**
 保存用户身高
 */
-(void)setUserHeight:(NSString *)userHeight;
/**
 保存用户体重
 */
-(void)setUserWeight:(NSString *)userWeight;
/**
 保存用户生日
 */
-(void)setUserBrithday:(NSString *)userBrithday;
/**
 保存用户性别
 */
-(void)setUserSex:(NSString *)userSex;
/**
 保存用户验证码
 */
-(void)setUserVerificationCode:(NSString *)UserVerificationCode;
/**
 保存用户登录情况
 */
-(void)setUserLogin:(NSString *)userLogin;
/**
 保存用户memberID
 */
-(void)setUserMemberID:(NSString *)userMemberID;
///**
// 保存用户动作完成总个数
// */
//-(void)setUserActs:(NSString *)userActs;
///**
// 保存用户粉丝个数
// */
//-(void)setUserFans:(NSString *)userFans;
///**
// 保存用户关注个数
// */
//-(void)setUserAttention:(NSString *)userAttention;
/////**
// 保存用户memberID
// */
//-(void)setUserMemberID:(NSString *)userMemberID;
///**
// 保存用户memberID
// */
//-(void)setUserMemberID:(NSString *)userMemberID;
///**
// 保存用户memberID
// */
//-(void)setUserMemberID:(NSString *)userMemberID;
///**
// 保存用户memberID
// */
//-(void)setUserMemberID:(NSString *)userMemberID;
///**
// 保存用户memberID
// */
//-(void)setUserMemberID:(NSString *)userMemberID;

#pragma mark - 得到用户信息
/**
 保存用户昵称
 */
- (NSString*)getUserName;
/**
 保存用户密码
 */
- (NSString*)getPassWord;
/**
 保存用户ID
 */
- (NSString*)getUserID;
/**
 保存用户token
 */
- (NSString*)getToken;
/**
 保存用户头像
 */
- (NSString*)getUserAvatar;
/**
 保存用户身高
 */
- (NSString*)getUserHeight;
/**
 保存用户体重
 */
- (NSString*)getUserWeight;
/**
 保存用户生日
 */
- (NSString*)getUserBrithday;
/**
 保存用户性别
 */
- (NSString*)getUserSex;
/**
 保存用户验证码
 */
- (NSString*)getUserVerificationCode;
/**
 保存用户登录情况
 */
- (NSString*)getUserLogin;
/**
 保存用户memberID
 */
- (NSString*)getUserMemberID;

/**
 移除所有用户信息
 */
-(void)removeAllUserInfo;



#pragma mark - 简单写法

/**
 *  缓存写入
 */
+ (void)putUserDefaults:(NSString *)value key:(NSString *)key;
/**
 *  缓存读取
 */
+ (NSString *)getUserDefaults:(NSString *)key;
/**
 *  缓存清除
 */
+ (void)clearUserDefaults:(NSString *)key;


@end
