//
//  LoginNavigationViewController.m
//  XFitClub
//
//  Created by figaro on 2017/3/22.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "LoginNavigationViewController.h"

@interface LoginNavigationViewController ()

@end

@implementation LoginNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置子视图为透明，只显示返回按钮。
    [self.navigationBar.subviews objectAtIndex:0].alpha = 0.0;
    
}


@end
