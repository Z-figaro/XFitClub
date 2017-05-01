    //
//  registerViewController.m
//  XFitClub
//
//  Created by 张鹏 on 2017/3/23.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "registerViewController.h"
#import "checkNumber.h"
#import "SVProgressHUD.h"

#import "Header.h"
#import "UIButton+countDown.h"
#import "APIManager.h"


@interface registerViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *registerStarButton;


@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phoneNumber.delegate = self;
    _checkNumber.delegate = self;
    
}

- (IBAction)checkverificationCodeNumber:(id)sender {
    
    //验证手机号是否是手机号——网络请求——
    
    if ([checkNumber checkTelNumber:_phoneNumber.text]) {
        //请求验证码
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,getVerificationCodeURL];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phonenumber"] = _phoneNumber.text;

        [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
            //如果成功接入后台
            if ([[responseObject objectForKey:@"errorcode"]integerValue]==0) {
               
                //获取验证码
                _verificationCode = responseObject[@"data"];
                
                //验证码读秒功能
                [_checkButton startWithTime:59 title:@"验证码" countDownTitle:@"秒" mainColor:RGBCOLOR(123, 138, 150, 1) countColor:[UIColor lightGrayColor]];
                
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

//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}
// 注册开始按钮
- (IBAction)registerOverButton:(id)sender {
        //数据准备
        NSString *url =[NSString stringWithFormat:@"%@%@",BaseURL,checkVerificationCodeURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phonenumber"] = _phoneNumber.text;
        params[@"verifycode"] = _checkNumber.text;
        
        //服务器验证
        [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
            
            if (responseObject[@"errorcode"] == 0) {
                
                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
                
               
                [self performSegueWithIdentifier:@"registerStar"sender:self];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"网络繁忙，请等待！"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
                
                
            }
         
        } WithFailurBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络出问题了！"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            
         
        }];
    
    
    
}
//键盘协议
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 收起键盘
    [self.view endEditing:YES];
}










































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
