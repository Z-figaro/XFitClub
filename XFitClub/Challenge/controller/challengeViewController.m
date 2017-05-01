//
//  challengeViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/26.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "challengeViewController.h"
#import "CarouselView.h"
#import "ZPPAccountTool.h"
#import "Header.h"
#import "challengeTableViewCell.h"
#import <SDWebImage/SDWebImageManager.h>

@interface challengeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *speicalChallengeArray;
    NSMutableArray *weekChallengeArray;
   
}
@property (weak, nonatomic) IBOutlet UIView *carouselView;
@property (weak, nonatomic) IBOutlet UITableView *challengeTableView;


- (void)initUserInterface;/**< 初始化用户界面 */
- (void)initDataSource;/**< 初始化数据源 */
@end

@implementation challengeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //局部变量给全局变量赋值要初始化
    speicalChallengeArray = [[NSMutableArray alloc] init];
    weekChallengeArray = [[NSMutableArray alloc] init];
    
    
    [self initDataSource];
    [self initUserInterface];
    
    
    
}
#pragma mark - Init methods
- (void)initDataSource{
    //data
    NSString *url               = [NSString stringWithFormat:@"%@%@",BaseURL,challengeHomeURL];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc]init];
    parmas[@"memberId"]         = [ShareUserModel getUserMemberID];
    parmas[@"tokenId"]          = [ShareUserModel getToken];
    //http
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:parmas WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
    
            speicalChallengeArray =  responseObject[@"data"][@"zhuanxiang"];
            weekChallengeArray    =  responseObject[@"data"][@"tiaozhan"];
            [self.challengeTableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus: responseObject[@"message"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } WithFailurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }];
    
    //轮播图
    
    
 
}
- (void)initUserInterface{
    //解决适配屏幕拉伸问题
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 40,-40);
    UIImage *navigationBGImage = [[UIImage imageNamed:@"home_navigationbar_background"]
                                  resizableImageWithCapInsets:insets];
    [self.navigationController.navigationBar setBackgroundImage:navigationBGImage forBarMetrics:UIBarMetricsDefault];
    
    //添加头视图
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImage *image = [UIImage imageNamed: @"challenge_topTitle"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    self.navigationItem.titleView = imageView;
    
    //取消分割线
    self.challengeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - 轮播图
- (void)banner{
    
    //网络图片数据准备
    //todo:数据准备
//    NSArray *imageArray =[];
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return speicalChallengeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    challengeTableViewCell *cell = [challengeTableViewCell cellWithTableView:tableView];
  
    cell.sportsName.text = [NSString stringWithFormat:@"%@", speicalChallengeArray[indexPath.row][@"act_name"]];
    
    [cell.sportsImage sd_setImageWithURL:[NSURL URLWithString:speicalChallengeArray[indexPath.row][@"act_img"]] placeholderImage:[UIImage imageNamed:@"train_actionIcon"]];
    cell.sportsNumber.text = [NSString stringWithFormat:@"%@",speicalChallengeArray[indexPath.row][@"act_id"]];
    
    //完成与否
    if (speicalChallengeArray[indexPath.row][@"state"]  == 0 ) {
        cell.statusImage.image = [UIImage imageNamed:@"challenge_go"];
    } else {
        cell.statusImage.image = [UIImage imageNamed:@"challenge_finish"];
    }
  
    
    return cell;
}

//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}
@end
