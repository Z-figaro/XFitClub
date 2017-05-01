//
//  userInfoViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/13.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "userInfoViewController.h"
#import "ZPPAccountTool.h"
#import "MainTabBarViewController.h"
#import "Header.h"

@interface userInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIImageView *userSexImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userHeight;
@property (weak, nonatomic) IBOutlet UILabel *userWeight;
@property (weak, nonatomic) IBOutlet UILabel *userBrithday;
@property (strong, nonatomic) IBOutlet UIButton *goBackMainButton;

@end

@implementation userInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //头像
    self.avatarImage.layer.cornerRadius  = 48;//裁成圆角
    self.avatarImage.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    
    //  给头像加一个圆形边框
    self.avatarImage.layer.borderWidth = 1.5f;//宽度
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;//颜色
    [_avatarImage setImage:_userHeadImage];
   
    //用户性别
    if ([[ShareUserModel getUserSex] isEqualToString:@"1"]) {
        _userSexImage.image = [UIImage imageNamed:@"register_man1"];
    } else {
        _userSexImage.image = [UIImage imageNamed:@"register_woman1"];
    }
    //用户名
    _userName.text = _userNameText;
    //身高
    _userHeight.text = _userHeightText;
    //体重
    _userWeight.text = _userWeightText;
    //生日
    _userBrithday.text = _userBrithdayText;
    
}

- (IBAction)goToMainView:(id)sender {
    
    //注册用户信息
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,registerURL];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"account"] = _userNameText;
    parmas[@"birthdate"] = _userBrithdayText;
    parmas[@"headurl"] = [ShareUserModel getUserAvatar];
    parmas[@"height"] = _userHeightText;
    parmas[@"password"] = [ShareUserModel getPassWord];
    parmas[@"phonenumber"] = [ShareUserModel getUserID];
    parmas[@"sex"] = [ShareUserModel getUserSex];
    parmas[@"weight"] = _userWeightText;
    
    NSLog(@"注册用户信息：%@",parmas);
    
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:parmas WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            //注册成功跳转
            
            [ShareUserModel setUserLogin:@"login"];
            [ShareUserModel setUserName:_userNameText];
            [ShareUserModel setUserHeight:_userHeightText];
            [ShareUserModel setUserWeight:_userWeightText];
            [ShareUserModel setUserBrithday:_userBrithdayText];
            
            [ShareUserModel setUserMemberID:responseObject[@"data"][@"token"][@"memberid"]];
            [ShareUserModel setUserToken:responseObject[@"data"][@"token"][@"token"]];
            
            NSLog(@"memberid == %@,token == %@",responseObject[@"data"][@"token"][@"memberid"],responseObject[@"data"][@"token"][@"token"]);
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainTabBarViewController *mainView = [story instantiateViewControllerWithIdentifier:@"mainView"];
            [self presentViewController:mainView animated:YES completion:nil];
            
            

        } else {
            [SVProgressHUD showErrorWithStatus:@"服务器错误"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } WithFailurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"注册资料有误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }];

}
//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}


@end
