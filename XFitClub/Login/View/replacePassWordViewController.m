//
//  replacePassWordViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/13.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "replacePassWordViewController.h"
#import "Header.h"
#import "checkNumber.h"
#import "LoginNavigationViewController.h"

@interface replacePassWordViewController ()
@property (weak, nonatomic) IBOutlet ZPPTextField *enterNewPassWord;
@property (weak, nonatomic) IBOutlet ZPPTextField *surePassWord;

@end

@implementation replacePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)goBackLoginButton:(id)sender {
    
    
    
    if ([checkNumber checkPassword:_enterNewPassWord.text]) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,findPassWordURL];
        NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
        parmas[@"newpwd"] = _enterNewPassWord.text;
        parmas[@"phonenumber"] = [ShareUserModel getUserID];
        parmas[@"verifycode"] = [ShareUserModel getUserVerificationCode];
        
        if ([_enterNewPassWord.text isEqualToString:_surePassWord.text]) {
            [ShareNetManager requestWithMethod:POST WithPath:url WithParams:parmas WithSuccessBlock:^(id responseObject) {
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                 [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
                [ShareUserModel setPwd:_enterNewPassWord.text];
                //界面跳转
                //跳转到主页面
                
                [self performSegueWithIdentifier:@"backToMainView" sender:self];
                
            } WithFailurBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"服务器错误"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];

            }];
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
