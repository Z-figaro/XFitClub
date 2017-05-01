//
//  MainTabBarViewController.m
//  XFitClub
//
//  Created by figaro on 2017/3/20.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //解决图片拉伸的问题
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    UIEdgeInsets insets=UIEdgeInsetsMake(5, 0, -5, 0);
    UIImage *tabbarImage = [[UIImage imageNamed:@"tabbar_background"] resizableImageWithCapInsets:insets];
    
    [self.tabBar setBackgroundImage:tabbarImage];
    

}

//他界面返回到此界面调用的方法
- (IBAction)MainTabbarViewUnwindSegue:(UIStoryboardSegue *)unwindSegue{
    
    
    
}


@end
