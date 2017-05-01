//
//  fitMixNumberViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/18.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "fitMixNumberViewController.h"
#import "ZFRadarChart.h"
#import "MainTabBarViewController.h"
#import "fitMixNumberTableViewCell.h"

@interface fitMixNumberViewController ()<ZFRadarChartDataSource,ZFRadarChartDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tabelHeadView;


@property (nonatomic, strong) ZFRadarChart * radarChart;
@property (nonatomic, assign) CGFloat height;
@end

@implementation fitMixNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self radioChartView];
    
}

- (IBAction)backButton:(id)sender {
    //跳转到mainView
    UIStoryboard *story                = [UIStoryboard storyboardWithName               :@"Main" bundle               :nil];
    MainTabBarViewController *mainView = [story instantiateViewControllerWithIdentifier :@"mainView"];
    [self presentViewController                                                         :mainView animated                                                         :YES completion                                                         :nil];

}

- (void)radioChartView{
    
    ZFRadarChart * radarChart        = [[ZFRadarChart alloc] initWithFrame :CGRectMake(0, 0, 375, 200)  ];
    radarChart.dataSource            = self;
    radarChart.delegate              = self;
    self.radarChart.itemFont         = [UIFont systemFontOfSize             :12.f];
    self.radarChart.polygonLineWidth = 2.f;
    self.radarChart.canRotation      = NO;
    [self.tableView.tableHeaderView addSubview                      :radarChart];
    [radarChart strokePath];
    
    
}
#pragma mark - dataSource & delegate

- (NSArray *)itemArrayInRadarChart:(ZFRadarChart *)radarChart{
    
    return @[@"爆发", @"耐力", @"柔韧", @"敏捷", @"力量"];
}

- (NSArray *)valueArrayInRadarChart:(ZFRadarChart *)radarChart{
    
    return @[@"4", @"10", @"4", @"9", @"7"];
    
}

- (CGFloat)radiusForRadarChart:(ZFRadarChart *)radarChart{
    
    return 70;
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    fitMixNumberTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"fitMixNumberCell" forIndexPath:indexPath];
    
    NSArray *nameArray = [[NSArray alloc] initWithObjects:@"综合",@"爆发",@"力量", @"耐力", @"柔韧", @"敏捷", nil];
    NSArray *fitNumberArray = @[@"4", @"10", @"4", @"9", @"7",@"100"];
    NSArray *fitOverArray = @[@"100", @"10", @"4", @"9", @"7",@"0"];
    
    cell.fitName.text = [NSString stringWithFormat:@"%@",nameArray[indexPath.row]];
    cell.fitNumber.text = fitNumberArray[indexPath.row];
    cell.fitOver.text = [NSString stringWithFormat:@"超过%@%@用户",fitOverArray[indexPath.row],@"%"];
    
    return cell;
}
@end
