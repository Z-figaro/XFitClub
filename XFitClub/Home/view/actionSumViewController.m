//
//  actionSumViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/18.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "actionSumViewController.h"
#import "MainTabBarViewController.h"
#import "NinaPagerView.h"
#import "Header.h"



@interface actionSumViewController ()<NinaPagerViewDelegate>
@property (nonatomic, strong) NinaPagerView *ninaPagerView;
@end

@implementation actionSumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor                      = [UIColor blackColor];
    self.ninaPagerView.delegate                    = self;
    [self.view addSubview :self.ninaPagerView];
}
- (IBAction)backButton:(id)sender {
    
    //跳转到mainView
    UIStoryboard *story                = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarViewController *mainView = [story instantiateViewControllerWithIdentifier:@"mainView"];
    [self presentViewController:mainView animated:YES completion:nil];

}
- (NSArray *)ninaTitleArray {
    return @[
             @"日",
             @"月",
             @"年",
             @"总",
             ];
}

- (NSArray *)ninaViewsArray {
    return @[
             @"baseViewController",
             @"baseViewController",
             @"baseViewController",
             @"SumViewController",
             ];
}

#pragma mark - LazyLoad
- (NinaPagerView *)ninaPagerView {
    if (!_ninaPagerView) {
        NSArray *titleArray            = [self ninaTitleArray];
        NSArray *vcsArray              = [self ninaViewsArray];
        CGRect pagerRect               = CGRectMake(0, 80, FRAME_WIDTH, FRAME_HEIGHT -80);
        _ninaPagerView                 = [[NinaPagerView alloc] initWithFrame:pagerRect WithTitles:titleArray WithVCs:vcsArray];
        _ninaPagerView.ninaPagerStyles = NinaPagerStyleSlideBlock;
    }
    return _ninaPagerView;
}

//在这里根据页面不同显示不同的数据
- (void)ninaCurrentPageIndex:(NSString *)currentPage {
    NSLog(@"Current page is %@",currentPage);
    //0-3
    _pageNumber = currentPage;
    
   
}


@end
