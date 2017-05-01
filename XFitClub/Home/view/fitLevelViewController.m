//
//  fitLevelViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/18.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "fitLevelViewController.h"
#import "MainTabBarViewController.h"

@interface fitLevelViewController ()

@end

@implementation fitLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)backbutton:(id)sender {
    
    //跳转到mainView
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarViewController *mainView = [story instantiateViewControllerWithIdentifier:@"mainView"];
    [self presentViewController:mainView animated:YES completion:nil];
}


@end
