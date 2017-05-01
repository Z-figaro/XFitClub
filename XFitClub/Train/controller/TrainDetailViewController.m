//
//  TrainDetailViewController.m
//  XFitClub
//
//  Created by 郭炜 on 2017/4/20.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "TrainDetailViewController.h"
#import "Header.h"
#import "PinLunCell.h"
#import "ActionCollectionViewCell.h"
#import "VideoCollectionViewCell.h"
#import "PowerCollectionCell.h"
#import "ActionViewController.h"
#import "TrainingViewController.h"

@interface TrainDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource> {
    NSMutableDictionary *dataSource1;//力量，耐力，爆发
    NSArray *powerTitlArray;
    NSMutableArray *dataSource2;//1.引体向上 2.俯卧撑
    NSMutableArray *dataSource3;//视频
    NSMutableArray *dataSource4;//评论
    NSString *woldid;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *tableView_power;
@property (weak, nonatomic) IBOutlet UICollectionView *actionCollection;
@property (weak, nonatomic) IBOutlet UILabel *numbersOfAction;
@property (weak, nonatomic) IBOutlet UICollectionView *videoCollection;
@property (weak, nonatomic) IBOutlet UITableView *pinlunTabelView;

@end

@implementation TrainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithDataSource];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    dataSource1 = [NSMutableDictionary dictionary];
    dataSource2 = [NSMutableArray array];
    dataSource3 = [NSMutableArray array];
    dataSource4 = [NSMutableArray array];
    self.tableView_power.delegate = self;
    self.tableView_power.dataSource = self;
    self.actionCollection.delegate = self;
    self.actionCollection.dataSource = self;
    self.videoCollection.delegate = self;
    self.videoCollection.dataSource = self;
    self.pinlunTabelView.delegate = self;
    self.pinlunTabelView.dataSource = self;
    [self configCollection];
    [self configCollection_Power];
    [self configCollection_Video];
}
#pragma mark - 数据
- (void)initWithDataSource {
    //请求数据
    powerTitlArray = @[@"力量",@"耐力",@"爆发",@"敏捷",@"柔韧"];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,traindetail];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"memberId"] = [ShareUserModel getUserMemberID];
    params[@"tokenId"] = [ShareUserModel getToken];
    params[@"wodId"] = self.wodid;
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
            @try {
                NSDictionary *dic = responseObject[@"data"];
                dataSource1 = dic[@"zhishu"];
                dataSource2 = dic[@"act"];
                dataSource3 = dic[@"acts_video"];
                dataSource4 = dic[@"content"];
                self.numbersOfAction.text = [NSString stringWithFormat:@"所有动作重复%@组",dic[@"allTime"]];
                self.nameLabel.text = [NSString stringWithFormat:@"训练日LV%@-%@",dic[@"lv"],dic[@"name"]];
                NSMutableString *tag = [NSMutableString string];
                for (int i = 0; i < [dic[@"tag"] count]; i ++) {
                    NSString *s = dic[@"tag"][i];
                    tag = [NSMutableString stringWithFormat:@"%@  #%@",tag,s];
                }
                self.tagsLabel.text = tag;
                [self.tableView_power reloadData];
                [self.videoCollection reloadData];
                [self.actionCollection reloadData];
                [self.pinlunTabelView reloadData];
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

#pragma mark - delegate&datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PinLunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PinLunCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PinLunCell" bundle:nil] forCellReuseIdentifier:@"PinLunCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PinLunCell"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.videoCollection]) {
        //视频播放的collectionview
        VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionViewCell" forIndexPath:indexPath];
        cell.videoName.text = [NSString stringWithFormat:@"%@",dataSource3[indexPath.row][@"name"]];
        [cell.videoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataSource3[indexPath.row][@"img"]]]];
        return cell;
    }else if ([collectionView isEqual:self.tableView_power]) {
        //指数的collectionview
        PowerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PowerCollectionCell" forIndexPath:indexPath];
        NSString *key = [dataSource1 allKeys][indexPath.row];
        cell.numberLabel.text = [NSString stringWithFormat:@"+%@",dataSource1[key]];
        cell.llLabel.text = powerTitlArray[indexPath.row];
        NSString *imageS = [NSString stringWithFormat:@"%@图标",powerTitlArray[indexPath.row]];
        cell.llImage.image = [UIImage imageNamed:imageS];
        return cell;
    }else {
        //动作的collectionview
        ActionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActionCollectionViewCell" forIndexPath:indexPath];
        cell.actionName.text = [NSString stringWithFormat:@"%ld %@",indexPath.row+1,dataSource2[indexPath.row][@"name"]];
        cell.numbersOfAction.text = [NSString stringWithFormat:@"%@",dataSource2[indexPath.row][@"number"]];
        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.videoCollection]) {
        //视频播放
        return dataSource3.count;
    }else if ([collectionView isEqual:self.tableView_power]) {
        //指数
        return dataSource1.count;
    }else {
        //动作
        return dataSource2.count;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.videoCollection]) {
        NSString *actId = dataSource2[indexPath.row][@"act_id"];
        ActionViewController *page = [ActionViewController new];
        page.actid = actId;
        [self.navigationController pushViewController:page animated:YES];
    }
}
#pragma mark - 事件
- (IBAction)seeMorePinlunButtonClixk:(id)sender {
    //查看更多评论
}

- (IBAction)joinPinlunButtonClick:(id)sender {
    //参与评论
}

- (IBAction)pyqButton:(id)sender {
    //朋友圈
}
- (IBAction)wxButton:(id)sender {
    //微信
}
- (IBAction)wbButton:(id)sender {
    //微博
}
- (IBAction)qqButton:(id)sender {
    //QQ
}
- (IBAction)qqkjButton:(id)sender {
    //QQ空间
}
- (IBAction)startButton:(id)sender {
    //开始训练按钮点击
    TrainingViewController *page = [TrainingViewController new];
    page.wodId = self.wodid;
    page.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - 初始化
- (void)configCollection {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(screenwidth/2-25, 40)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    [self.actionCollection setCollectionViewLayout:flowLayout];
    [self.actionCollection registerNib:[UINib nibWithNibName:@"ActionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ActionCollectionViewCell"];
}
- (void)configCollection_Video {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(5/3*104, 104)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    [self.videoCollection setCollectionViewLayout:flowLayout];
    [self.videoCollection registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VideoCollectionViewCell"];
}

- (void)configCollection_Power {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(45, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    [self.tableView_power setCollectionViewLayout:flowLayout];
    [self.tableView_power registerNib:[UINib nibWithNibName:@"PowerCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PowerCollectionCell"];
}




@end
