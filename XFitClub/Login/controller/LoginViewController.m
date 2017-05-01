//
//  LoginViewController.m
//  XFitClub
//
//  Created by figaro on 2017/3/20.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "Header.h"


@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


- (void)initUserInterface;/**< 初始化用户界面 */
- (void)initDataSource;/**< 初始化数据源 */
@end

@implementation LoginViewController

#pragma mark - 界面生命周期
//三方登录是否显示
bool isShown = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self initUserInterface];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    

    [super viewWillDisappear:animated];
}



#pragma mark - Init methods
- (void)initDataSource{
    
}
- (void)initUserInterface{
    //三方登录开始位置移除屏幕
    [_theOtherLoginView setBounds:CGRectMake(500, 0, 0, 0)];
    
    //键盘代理
    _phoneNumberText.delegate = self;
    _passWordText.delegate    = self;
    
}


#pragma mark - button点击事件

- (IBAction)loginButton:(id)sender {
        //todo:登录事件
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,loginURL];
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc]init];
    parmas[@"phonenumber"] = _phoneNumberText.text;
    parmas[@"password"] = _passWordText.text;
    parmas[@"type"] = @"0";
    
    if ([checkNumber checkTelNumber:_phoneNumberText.text] && [checkNumber checkPassword:_passWordText.text]) {
        [ShareNetManager requestWithMethod:POST WithPath:url WithParams:parmas WithSuccessBlock:^(id responseObject) {
            if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
                
                [ShareUserModel setUserLogin:@"login"];
                [ShareUserModel setUserToken:responseObject[@"data"][@"token"][@"token"]];
                [ShareUserModel setUserMemberID:responseObject[@"data"][@"token"][@"memberid"]];
                //跳转到mainView
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MainTabBarViewController *mainView = [story instantiateViewControllerWithIdentifier:@"mainView"];
                [self presentViewController:mainView animated:YES completion:nil];
                
            } else {
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            }
        } WithFailurBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"账号或密码输入错误"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"账号或密码格式有误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }
    
}

- (IBAction)registerButton:(id)sender {
}
//三方登录页面
- (IBAction)theOtherLoginView:(id)sender {
    if (!isShown) {
       
        [UIView animateWithDuration:0.25 animations:^{
            [_theOtherLoginView setBounds:CGRectMake(0, 0, 278, 65)];
        }];
        isShown = true;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
             [_theOtherLoginView setBounds:CGRectMake(500, 0, 0, 0)];
        }];
        isShown = false;
    }
}

- (IBAction)forgetPassWordView:(id)sender {
}





//他界面返回到此界面调用的方法
- (IBAction)loginMainViewUnwindSegue:(UIStoryboardSegue *)unwindSegue{
    
    
}

//键盘协议
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    // 收起键盘
    [self.view endEditing:YES];
}

//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}

@end
