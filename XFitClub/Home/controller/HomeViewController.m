//
//  HomeViewController.m
//  XFitClub
//
//  Created by figaro on 2017/3/17.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Header.h"

@interface HomeViewController ()

//系统消息
@property (copy, nonatomic) NSString *noticeNumber;
@property (weak, nonatomic) IBOutlet UIButton *noticeButton;
@property (strong, nonatomic) IBOutlet UIScrollView *homeScrollView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set navBar
        
    UIImage *image = [UIImage imageNamed: @"x-fit-club.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    self.navigationItem.titleView = imageView;
    
    
    //todo: enter the system noticeNumber
    _noticeNumber = @"0";
    
//    _homeScrollView.contentSize = CGSizeEqualToSize(self., <#CGSize size2#>)
    
    [self setNoticeButton];
  
   
}

- (void)viewWillAppear:(BOOL)animated {
    

    [super viewWillAppear:animated];
    
    
    
}

/**
 系统信息按钮
 */
- (void)setNoticeButton{
    
    if ([_noticeNumber isEqualToString:@"0"]) {
        [_noticeButton setTitle:_noticeNumber forState:UIControlStateNormal];
        UIImage *image = [[UIImage imageNamed:@"navigation_home_NoNotice"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_noticeButton setImage:image forState:UIControlStateNormal];
    } else {
        [_noticeButton setTitle:_noticeNumber forState:UIControlStateNormal];
        UIImage *image = [[UIImage imageNamed:@"navigation_home_Notice"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_noticeButton setImage:image forState:UIControlStateNormal];
    }
}

@end

