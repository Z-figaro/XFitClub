//
//  challengeViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/26.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "challengeViewController.h"
#import "ZPPAccountTool.h"
#import "Header.h"
#import "challengeTableViewCell.h"
#import <SDWebImage/SDWebImageManager.h>
#import "SDCycleScrollView.h"

@interface challengeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>{
    NSMutableArray *speicalChallengeArray;
    NSMutableArray *weekChallengeArray;
    NSMutableArray *imageURLArray;
   
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
 
    [self banner];
    
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
            imageURLArray = [NSMutableArray new];
            for (int i = 0 ; i < weekChallengeArray.count; i++) {
                
                NSString *imageString = weekChallengeArray[i][@"wod_img"];
                [imageURLArray addObject:imageString];
    
            }
            //轮播图
            UIImage *placeholderImage = [UIImage imageNamed:@"challenge_weekContent"];
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenwidth, 220) delegate:self placeholderImage:placeholderImage];
            cycleScrollView.currentPageDotColor = [UIColor yellowColor];
            cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            cycleScrollView.imageURLStringsGroup = imageURLArray;
            
            NSLog(@"url == %@",imageURLArray);
            [self.carouselView addSubview:cycleScrollView];
            [self.challengeTableView reloadData];
            
        } else {
            [SVProgressHUD showErrorWithStatus: responseObject[@"message"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } WithFailurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }];
    
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
    //fix：数据源时序不同，显示不出来
    UIImage *placeholderImage = [UIImage imageNamed:@"challenge_weekContent"];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenwidth, 220) delegate:self placeholderImage:placeholderImage];
    cycleScrollView.currentPageDotColor = [UIColor yellowColor];
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.imageURLStringsGroup = imageURLArray;
    
    NSLog(@"url == %@",imageURLArray);
    [self.carouselView addSubview:cycleScrollView];
    
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
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
    if ([speicalChallengeArray[indexPath.row][@"state"] isEqualToString:@"0"]) {
        cell.statusImage.image = [UIImage imageNamed:@"challenge_false"];
    } else {
        cell.statusImage.image = [UIImage imageNamed:@"challenge_true"];
    }
  
    
    return cell;
}

//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}
@end
