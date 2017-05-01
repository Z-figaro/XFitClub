//
//  EndTrainViewController.m
//  XFitClub
//
//  Created by 郭炜 on 2017/4/21.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "EndTrainViewController.h"
#import "Header.h"
#import "PowerCollectionCell.h"
#import "ActionCollectionViewCell.h"

@interface EndTrainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableDictionary *dataSource1;//力量，耐力，爆
    NSArray *powerTitlArray;
    NSMutableArray *dataSource2;//1.引体向上 2.俯卧撑
}
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *trainName;
@property (weak, nonatomic) IBOutlet UICollectionView *actionCollecTion;
@property (weak, nonatomic) IBOutlet UILabel *numberOfAction;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UICollectionView *tableView_power;

@end

@implementation EndTrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithDataSource];
}

#pragma mark - 数据
- (void)initWithDataSource {
    //请求数据
    powerTitlArray = @[@"力量",@"耐力",@"爆发",@"敏捷",@"柔韧"];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,finishixunlian];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"memberId"] = [ShareUserModel getUserMemberID];
    params[@"tokenId"] = [ShareUserModel getToken];
    params[@"yundongId"] = self.yundongId;
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
            @try {
                NSDictionary *dic = responseObject[@"data"];
                dataSource1 = dic[@"zhishu"];
                dataSource2 = dic[@"acts"];
                NSDictionary *member = dic[@"member"];
                [self.headPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",member[@"portrait_url"]]]];
                self.userName.text = member[@"member_name"];
                self.numberOfAction.text = [NSString stringWithFormat:@"所有动作重复%@组",self.data[@"allTime"]];
                self.trainName.text = [NSString stringWithFormat:@"训练日LV%@-%@",self.data[@"lv"],self.data[@"name"]];
                [self.tableView_power reloadData];
                [self.actionCollecTion reloadData];
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.tableView_power]) {
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
    if ([collectionView isEqual:self.tableView_power]) {
        return dataSource1.count;
    }else {
        return dataSource2.count;
    }
}

#pragma mark - 事件
- (IBAction)finishiButton:(id)sender {
    [self.navigationController popToViewController:[self.navigationController viewControllers][1] animated:YES];
}

- (IBAction)shareButton:(id)sender {
}

#pragma mark - 初始化
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

- (void)configCollection {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(screenwidth/2-25, 40)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    [self.actionCollecTion setCollectionViewLayout:flowLayout];
    [self.actionCollecTion registerNib:[UINib nibWithNibName:@"ActionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ActionCollectionViewCell"];
}
@end
