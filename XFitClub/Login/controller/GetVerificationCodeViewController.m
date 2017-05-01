//
//  GetVerificationCodeViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/7.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "GetVerificationCodeViewController.h"
#import "Header.h"
#import "UIButton+countDown.h"



@interface GetVerificationCodeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet ZPPTextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet ZPPTextField *verificationCodeText;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *gotoNextViewButton;

@end

@implementation GetVerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phoneNumberText.delegate = self;
    _verificationCodeText.delegate = self;
    
}
//获取验证码
- (IBAction)getVerificationCodeButton:(id)sender {
    
    //验证手机号是否是手机号——网络请求——
    
    if ([checkNumber checkTelNumber:_phoneNumberText.text]) {
        //请求验证码
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,getVerificationCodeURL];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phonenumber"] = _phoneNumberText.text;
        params[@"type"] = @"register";
        [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
            //如果成功接入后台
            if ([[responseObject objectForKey:@"errorcode"]integerValue]==0) {
                
                //获取验证码,手机号
                _gettedVerificationCode = responseObject[@"data"];
                [ShareUserModel setUserVerificationCode:_gettedVerificationCode];
                _phoneNumber = _phoneNumberText.text;
                
                //验证码读秒功能
                [_getVerificationCodeButton startWithTime:59 title:@"获取验证码" countDownTitle:@"秒" mainColor:RGBCOLOR(0, 0, 0, 1) countColor:[UIColor grayColor]];
                
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
                
            } else {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            }
        } WithFailurBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"验证码发送失败"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }];
        
    } else {
        //验证码请求不成功
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        
    }
    
}
//验证成功跳转界面
- (IBAction)gotoNextView:(id)sender {
    //数据准备
    NSString *url =[NSString stringWithFormat:@"%@%@",BaseURL,checkVerificationCodeURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phonenumber"] = _phoneNumberText.text;
    params[@"verifycode"] = _verificationCodeText.text;
    
    //服务器验证
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
        
        if ([_verificationCodeText.text isEqualToString:_gettedVerificationCode]) {
            if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
                //保存用户注册手机号
                [ShareUserModel setUserID:_phoneNumberText.text];
                //提示框
                [SVProgressHUD showSuccessWithStatus:@"请设置6—18位数字和字母组合密码"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
                //界面跳转到密码设置页
                [self performSegueWithIdentifier:@"pushPassWordView"sender:self];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"网络繁忙，请等待！"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"验证码输入错误"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
        
        
        
    } WithFailurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络出问题了！"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        
        
    }];

}



#pragma mark - help Method
//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}

#pragma mark - textfield Delegate
//键盘协议
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 收起键盘
    [self.view endEditing:YES];
}

@end
