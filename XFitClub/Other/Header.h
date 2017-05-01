//
//  Header.h
//  XFitClub
//
//  Created by 张鹏 on 2017/3/26.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#ifndef Header_h
#define Header_h

//RGB
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromRGB(rgbValue,ALPHA) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(ALPHA)]
#define WIDTH(v)           (v).frame.size.width

//屏幕
#define FRAME_WIDTH       self.view.frame.size.width
#define FRAME_HEIGHT      self.view.frame.size.height
#define K_MAINCOLOR RGBCOLOR(0, 204, 255, 1)
///屏幕的宽高
#define MAIN_FRAME [[UIScreen mainScreen] bounds]
///屏幕宽
#define screenwidth [UIScreen mainScreen].bounds.size.width
///屏幕高
#define screenheight [UIScreen mainScreen].bounds.size.height

//支持文件
#import "UIImage+compressIMG.h"
#import "ZPPTextField.h"
#import "ZPPAccountTool.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "APIManager.h"
#import "checkNumber.h"
#import "UIView+TargetAction.h"
#import "UIButton+EnlargeTouchArea.h"
#import "NSCalendar+ST.h"
#import "UIView+Extensions.h"

#define weakify(var)   __weak typeof(var) weakSelf = var
#define strongify(var) __strong typeof(var) strongSelf = var
//URL
#define BaseURL                         @"http://xfit.webuildus.com/index.php/"             //baseURL

//APIKey ？？？:是否使用？
#define apikey                          @""
//Member
#define getVerificationCodeURL          @"Member/getVerifyCode"                             //获取验证码
#define checkVerificationCodeURL        @"Member/checkVerifyCode"                           //确认验证码
#define checkUserNameURL                @"Member/MemberName"                                //检验用户名
#define bindPhoneNumberURL              @"Member/binding"                                   //绑定手机
#define findPassWordURL                 @"Member/findPassword"                             //密码确定
#define uploadAvatarURL                 @"Member/uploadImg"                                 //上传头像
#define registerURL                     @"Member/registerPhone"                             //注册
#define loginURL                        @"Member/login"                                     //登录
#define homeURL                         @"Member/home"                                      //首页信息
#define userCenterURL                   @"Member/getMember"                               //用户修改信息页
#define changeUserInfoURL               @"Member/modifyMember"                              //修改用户信息
#define taptrain                        @"Train/getOneTrain"                             //点击训练
#define actdetail                       @"Train/getOneAct"                                //动作详情
#define traindetail                     @"Train/trainingDetails"                           //训练详情
#define uploadxunlian                   @"Train/uploadXunlian"                           //上传训练信息
#define finishixunlian                  @"Train/endXunlian"                                //结束训练
#define challengeHomeURL                @"Change/getChange"                                 //挑战首页

/**Dubug相关*/

#ifdef DEBUG
#define MyLog(format,...)  NSLog((@"[函数名:%s]\n" "[行号:%d]\n" format),__FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define MyLog(...)
#endif

#endif /* Header_h */
