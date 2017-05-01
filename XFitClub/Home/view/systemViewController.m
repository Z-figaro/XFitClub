//
//  systemViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/18.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "systemViewController.h"
#import "userCenterViewController.h"
#import "ZPPAccountTool.h"
#import "LoginNavigationViewController.h"

@interface systemViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *wifiSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lightSwitch;
@property (weak, nonatomic) IBOutlet UIButton *clearCache;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation systemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setWifiSwitch];
    [self setLightSwitch];
}
#pragma mark - WIFI_Switch

- (void)setWifiSwitch{
    _wifiSwitch.on = YES;
    _wifiSwitch.tintColor = [UIColor cyanColor];
    _wifiSwitch.onTintColor = [UIColor cyanColor];
   
}
- (IBAction)wifiAction:(id)sender {
    //todo:添加wifi下自动上传视频的设定
}
#pragma mark - light_Switch
- (void)setLightSwitch{
        self.lightSwitch.on = YES;
        self.lightSwitch.tintColor =  [UIColor cyanColor];
        self.lightSwitch.onTintColor =  [UIColor cyanColor];
}
- (IBAction)lightAction:(id)sender {
    if (_lightSwitch.on) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    } else {
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}
#pragma mark - 清理缓存 和注销
- (IBAction)clearCache:(id)sender {
    //todo:清理缓存
}
- (IBAction)logoutButton:(id)sender {
    //登出
    [ShareUserModel removeAllUserInfo];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginNavigationViewController *loginView = [story instantiateViewControllerWithIdentifier:@"loginNaviView"];
    [self presentViewController:loginView animated:YES completion:nil];
}

- (IBAction)systemViewControllerUnwindSegue:(UIStoryboardSegue *)segue{
    
}
@end
