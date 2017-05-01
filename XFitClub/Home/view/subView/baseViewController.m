//
//  baseViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/20.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "baseViewController.h"
#import "TableViewCell.h"
#import "ZFChart.h"
#import "Header.h"
#import "actionSumViewController.h"

@interface baseViewController ()<UITableViewDelegate,UITableViewDataSource,ZFBarChartDelegate,ZFGenericChartDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *chartView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSArray *chartNameArray;//名称数组
@property (nonatomic, strong) NSArray *chartValueArray;//柱状图值

@end

@implementation baseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    //todo:柱状图set,
    _chartView.contentSize = CGSizeMake(FRAME_WIDTH*3, 152);//根据数组的个数确定宽度
    _chartView.pagingEnabled = YES;
    _chartView.contentOffset = CGPointMake(FRAME_WIDTH, 152);
    
    
    ZFBarChart *chart = [[ZFBarChart alloc] initWithFrame:CGRectMake(- 50, 0, FRAME_WIDTH*3,152)];
    chart.delegate = self;
    chart.dataSource = self;
    chart.xAxisColor = ZFLightGray;
    chart.isShowAxisArrows = NO;
    chart.isShowAxisLineValue = NO;
    chart.shadowColor = [UIColor darkGrayColor];
    chart.axisLineValueColor = ZFClear;
    chart.yAxisColor = ZFClear;
    chart.isShowXLineSeparate = NO;
    chart.isShowYLineSeparate = NO;
    chart.backgroundColor = [UIColor darkGrayColor];
    [_chartView addSubview:chart];
    [chart strokePath];
    
    [[self screenEdgePanGestureRecognizer] requireGestureRecognizerToFail:self.chartView.panGestureRecognizer];
}
#pragma mark - network
//todo：从actionSum给到页数，根据页数选择加载什么数据

#pragma mark - tableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [TableViewCell xibTableViewCell];
        //todo:cell赋值
        
//        cell.timeData.text =
        
    }
    
    return cell;
}

#pragma mark - chartView

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"13", @"25", @"34", @"22", @"11", @"55",@"37"];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"1月1日", @"1月2日", @"1月3日", @"1月4日", @"1月5日", @"1月6日",@"1月7日"];
}
- (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart{
    
    return 40;
}
- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFCyan];
}

- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex bar:(ZFBar *)bar popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)barIndex);
    
    //可在此处进行bar被点击后的自身部分属性设置,可修改的属性查看ZFBar.h
    bar.barColor = ZFGold;
    bar.isAnimated = YES;
    //    bar.opacity = 0.5;
    [bar strokePath];
    
    //可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    //    popoverLabel.hidden = NO;
}
#pragma mark - 手势冲突
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    
    if (self.navigationController.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers){
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

@end
