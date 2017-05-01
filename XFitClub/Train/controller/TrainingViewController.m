//
//  TrainingViewController.m
//  XFitClub
//
//  Created by 郭炜 on 2017/4/21.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "TrainingViewController.h"
#import "TrainCell.h"
#import "Header.h"
#import "ActionViewController.h"
#import "EndTrainViewController.h"

static NSString *kcell = @"kTrainCell";
@interface TrainingViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *dataSource;
    NSDictionary *dicData;
    int minus;
    int percens;
    int seconds;
    BOOL isStop;
}
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanTingButton;//暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isStop = YES;
    dicData = [NSDictionary dictionary];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self initWithDataSource];
}

#pragma mark - 数据
- (void)initWithDataSource {
    //请求数据
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,taptrain];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"memberId"] = [ShareUserModel getUserMemberID] ;
    params[@"tokenId"] = [ShareUserModel getToken];
    //    params[@"time"] = [NSString stringWithFormat:@"%ld-%ld-%ld",[NSCalendar currentYear],[NSCalendar currentMonth],[NSCalendar currentDay]];
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
            @try {
                NSDictionary *dic = responseObject[@"data"];
                dicData = dic;
                dataSource = dic[@"act"];
                [self.tableView reloadData];
                self.nameText.text = [NSString stringWithFormat:@"训练日LV%@-%@",dic[@"lv"],dic[@"name"]];
                NSMutableString *tag = [NSMutableString string];
                for (int i = 0; i < [dic[@"tag"] count]; i ++) {
                    NSString *s = dic[@"tag"][i];
                    tag = [NSMutableString stringWithFormat:@"%@#%@",tag,s];
                }
                self.tagsLabel.text = tag;
                [self start];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } WithFailurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }];
    
}

#pragma mark - delegate & datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrainCell *cell = [tableView dequeueReusableCellWithIdentifier:kcell];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"TrainCell" bundle:nil] forCellReuseIdentifier:kcell];
        cell = [tableView dequeueReusableCellWithIdentifier:kcell];
    }
    [cell.trainImage sd_setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:@"train_actionIcon"]];
    cell.timesLabel.text = [NSString stringWithFormat:@"%@次",dataSource[indexPath.row][@"number"]];
    cell.name.text = [NSString stringWithFormat:@"%@",dataSource[indexPath.row][@"name"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *actId = dataSource[indexPath.row][@"act_id"];
    ActionViewController *page = [ActionViewController new];
    page.actid = actId;
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - 事件
- (IBAction)zanTingButton:(id)sender {
    //暂停按钮点击
    UIButton *btn = (UIButton *)sender;
    if (isStop) {
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate date]];
        isStop = NO;
    }else{
        [btn setTitle:@"继续" forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
        isStop = YES;
    }
}

- (IBAction)finishButton:(id)sender {
    //结束按钮点击
    [_timer setFireDate:[NSDate distantFuture]];
    isStop = YES;
    [self.zanTingButton setTitle:@"继续" forState:UIControlStateNormal];
    //获取时间 上传到服务器
    //判断是否大于两分钟
    if (minus >= 2) {
        //大于两分钟
        [self uploadTrainDataWithSecond:minus*60+seconds];
    }else {
        //小于两分钟
        [SVProgressHUD showWithStatus:@"训练时间过短!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
        });
    }
    
}

-(void)startTimer{
    percens++;
    if(percens==100){
        seconds++;
        percens = 0;
    }
    if (seconds == 60) {
        minus++;
        seconds = 0;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d.%02d",minus,seconds,percens];
}

- (void)start {
    //数据请求完之后 再打开计时器
    [_timer setFireDate:[NSDate date]];
    isStop = NO;
}

- (void)uploadTrainDataWithSecond:(int)second {
    //上传训练信息
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,uploadxunlian];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"memberId"] = [ShareUserModel getUserMemberID] ;
    params[@"tokenId"] = [ShareUserModel getToken];
    params[@"playTime"] = [NSNumber numberWithInt:second];
    params[@"wodId"] = self.wodId;
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
            @try {
                [SVProgressHUD showWithStatus:responseObject[@"message"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    if ([responseObject[@"yundong_id"] length] > 0) {
                        EndTrainViewController *page = [EndTrainViewController new];
                        page.yundongId =responseObject[@"yundong_id"];
                        page.data = dicData;
                        [self.navigationController pushViewController:page animated:YES];
                    }else {
                        [self.navigationController popToViewController:[self.navigationController viewControllers][1] animated:YES];
                    }
                    
                });
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } WithFailurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }];
}
//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}

@end
