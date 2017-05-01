//
//  userInfoSexViewController.m
//  XFitClub
//
//  Created by figaro on 2017/3/27.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "userInfoSexViewController.h"
#import "ZPPAccountTool.h"
#import "SVProgressHUD.h"

@interface userInfoSexViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sexNextButton;
@property (weak, nonatomic) IBOutlet UIImageView *sexAvatarView;
@property (copy, nonatomic) NSString* sex;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (strong,nonatomic) UIButton* tmpButton;
@property (weak, nonatomic) IBOutlet UIButton *feimaleButton;


@end

@implementation userInfoSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAvatarView];
    
    [self.maleButton addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.feimaleButton addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonSelected:(UIButton*)sender{
    if (_tmpButton == nil){
        sender.selected = YES;
        _tmpButton = sender;
    }
    else if (_tmpButton !=nil && _tmpButton == sender){
        sender.selected = YES;
    }
    
    if (_maleButton.selected == YES) {
        _sex = @"male";
        if (_feimaleButton.selected == YES) {
            _sex = @"female";
        } else {
            _sex = nil;
        }
    }
}

- (IBAction)nextButton:(id)sender {
    if (_sex == nil) {
        [SVProgressHUD showWithStatus:@"请选择性别"];
        [SVProgressHUD dismissWithDelay:1];
        _sexNextButton.userInteractionEnabled = NO;
    } else {
        [ZPPAccountTool putUserDefaults:_sex key:@"userInfoSex"];
        _sexNextButton.userInteractionEnabled = YES;
    }
}

-(void)setAvatarView{
    //  把头像设置成圆形
    // set the view to 正方形就正常了
    self.sexAvatarView.layer.cornerRadius=self.sexAvatarView.frame.size.width/2;//裁成圆角
    self.sexAvatarView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    //  给头像加一个圆形边框
    self.sexAvatarView.layer.borderWidth = 1.5f;//宽度
    self.sexAvatarView.layer.borderColor = [UIColor whiteColor].CGColor;//颜色
}


@end
