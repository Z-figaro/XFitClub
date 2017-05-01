//
//  HomeNavigationController.m
//  XFitClub
//
//  Created by 张鹏 on 2017/3/11.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "HomeNavigationController.h"

@interface HomeNavigationController ()
@property(nonatomic, strong) UIView *titleView;
@end

@implementation HomeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解决适配屏幕拉伸问题
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 40,-40);
    UIImage *navigationBGImage = [[UIImage imageNamed:@"home_navigationbar_background"]
                                  resizableImageWithCapInsets:insets];
    [self.navigationBar setBackgroundImage:navigationBGImage forBarMetrics:UIBarMetricsDefault];

    
    self.navigationController.navigationBar.translucent = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    
}

- (void)viewWillAppear:(BOOL)animated{
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
