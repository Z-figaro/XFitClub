//
//  userInfoNameViewController.m
//  XFitClub
//
//  Created by figaro on 2017/3/27.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "userInfoNameViewController.h"
#import "AvatarViewController.h"
#import "ZPPAccountTool.h"

@interface userInfoNameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *nameAvatarView;

@property (weak, nonatomic) IBOutlet UITextField *userInfoName;
@property (weak, nonatomic) IBOutlet UIButton *nameNextButton;

@end

@implementation userInfoNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAvatarView];
    
}
//
-(void)setAvatarView{
    //  把头像设置成圆形
    // set the view to 正方形就正常了
    self.nameAvatarView.layer.cornerRadius=self.nameAvatarView.frame.size.width/2;//裁成圆角
    self.nameAvatarView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    //  给头像加一个圆形边框
    self.nameAvatarView.layer.borderWidth = 1.5f;//宽度
    self.nameAvatarView.layer.borderColor = [UIColor whiteColor].CGColor;//颜色
}

- (IBAction)nextButton:(id)sender {
    
    if (_userInfoName.text == nil) {
        _nameNextButton.userInteractionEnabled = NO;
    } else {
        [ZPPAccountTool putUserDefaults:_userInfoName.text key:@"userInfoName"];
        _nameNextButton.userInteractionEnabled = YES;
        [self performSegueWithIdentifier:@"nameToSex"sender:self];
    }
}


@end
