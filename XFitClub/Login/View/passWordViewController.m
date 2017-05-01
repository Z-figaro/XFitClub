//
//  passWordViewController.m
//  XFitClub
//
//  Created by 张鹏 on 2017/4/9.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "passWordViewController.h"
#import "Header.h"


@interface passWordViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet ZPPTextField *passWordText;
@property (strong, nonatomic) IBOutlet ZPPTextField *checkPassWordText;
@property (strong, nonatomic) IBOutlet UIButton *gotoNextView;

@end

@implementation passWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
//Fix:当前业务逻辑下,不使用
- (void)checkPassword{
    
    if ([checkNumber checkPassword:_passWordText.text]) {
          if ([_passWordText.text isEqualToString:_checkPassWordText.text]) {
            [self gotoNextView:_gotoNextView];
        } else {
            [SVProgressHUD showErrorWithStatus:@"两次密码不相同"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"请输入6—18位数字和字母组合密码"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];
    }
}

- (IBAction)gotoNextView:(id)sender {

    if ([checkNumber checkPassword:_passWordText.text]) {
        if ([_passWordText.text isEqualToString:_checkPassWordText.text]) {
            
            NSLog(@"phonenumber = %@ verifycode = %@ password = %@",[ShareUserModel getUserID],[ShareUserModel getUserVerificationCode],_passWordText.text);
            
            //保存用户注册手机号
            [ShareUserModel setPwd:_passWordText.text];
            //界面跳转到注册详情
            [self performSegueWithIdentifier:@"pushUserInfoView"sender:self];
        } else {
            [SVProgressHUD showErrorWithStatus:@"两次密码不相同"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"请输入6—18位数字和字母组合密码"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];
    }
}

#pragma mark - help Method
//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}
//键盘协议
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 收起键盘
    [self.view endEditing:YES];
}

@end
