//
//  bindingViewController.m
//  XFitClub
//
//  Created by 张鹏 on 2017/4/18.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "bindingViewController.h"
#import "ZPPAccountTool.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface bindingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumber;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end

@implementation bindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //头像
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width /2;
    self.userAvatar.layer.masksToBounds = YES;
    NSString *string = [NSString stringWithFormat:@"%@%@",@"http://xfit.webuildus.com",[ShareUserModel getUserAvatar]];
    NSLog(@"urlstring == %@",string);
    [_userAvatar sd_setImageWithURL:[NSURL URLWithString:string]];

    _userPhoneNumber.text = [ShareUserModel getUserID];
    NSLog(@"phone == %@",[ShareUserModel getUserID]);
    _userName.text = [NSString stringWithFormat:@"%@%@",@"MemberID = ",[ShareUserModel getUserMemberID]];
    
    [_accountLabel setText:@"已注册"];

}
@end

