//
//  trainViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/9.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "trainViewController.h"
#import "ZPPAccountTool.h"
#import "Header.h"
#import "TrainCell.h"
#import "TrainCollectionCell.h"
#import "VIPBuyView.h"
#import "ActionViewController.h"
#import "TrainDetailViewController.h"

static NSString *kcell = @"kTrainCell";
@interface trainViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>{
    NSMutableArray *dataSource;
    NSString *wodid;
}
@property (weak, nonatomic) IBOutlet UIImageView *trainHomeBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *startTrainButton;
@property (weak, nonatomic) IBOutlet UILabel *headName;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (nonatomic, strong) UIView *popBackView;
@property (nonatomic, strong) VIPBuyView *vipBuy;
@end

@implementation trainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [NSMutableArray array];
    [self chooseBackgroundImage];
    [self initWithDataSource];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
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
                dataSource = dic[@"act"];
                wodid = [NSString stringWithFormat:@"%@",dic[@"wod_id"]];
                [self.tableView reloadData];
                self.headName.text = [NSString stringWithFormat:@"训练日LV%@-%@",dic[@"lv"],dic[@"name"]];
                NSMutableString *tag = [NSMutableString string];
                for (int i = 0; i < [dic[@"tag"] count]; i ++) {
                    NSString *s = dic[@"tag"][i];
                    tag = [NSMutableString stringWithFormat:@"%@#%@",tag,s];
                }
                self.tagLabel.text = tag;
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
#pragma mark - 界面
- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSArray *views = @[self.backView,self.view1,self.view2,self.collectionView];
    for (UIView *view in views) {
        [self setBackColorWithAlphaWithView:view];
    }

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self configCollection];
}

- (void)setBackColorWithAlphaWithView:(UIView *)view {
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}
//选择背景图片
- (void)chooseBackgroundImage{
    
    if ([[ShareUserModel getUserSex] isEqualToString:@"1"]) {
        _trainHomeBackgroundView.image = [UIImage imageNamed:@"train_woman_background"];
    } else {
        _trainHomeBackgroundView.image = [UIImage imageNamed:@"train_man_background"];
    }
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
//collectionview
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TrainCollectionCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

#pragma mark - 事件
- (IBAction)startTrainButtonClick:(id)sender {
    //开始训练按钮点击
    TrainDetailViewController *page = [TrainDetailViewController new];
    page.wodid = wodid;
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)vipButtonClick:(id)sender {
    //VIP入口按钮点击
    [self.view addSubview:self.popBackView];
    [self.popBackView addSubview:self.vipBuy];
    [UIView animateWithDuration:1.0 animations:^{
        self.vipBuy.frame = CGRectMake(60, screenheight/2-50, screenwidth-120, (screenwidth-120)*291/526);
    }];
}

- (void)hide {
    if (self.vipBuy) {
        [UIView animateWithDuration:1.0 animations:^{
            self.vipBuy.frame = CGRectMake(60, -370, screenwidth-120, (screenwidth-120)*291/526);
        }completion:^(BOOL finished) {
            [self.popBackView removeFromSuperview];
            [self.vipBuy removeFromSuperview];
        }];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.vipBuy]) {
        return NO;
    }
    return YES;
}
#pragma mark - 初始化
- (void)configCollection {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(50, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.layer.masksToBounds = YES;
    self.collectionView.layer.borderWidth = 0.3f;
    self.collectionView.layer.borderColor = RGBCOLOR(204, 204, 204, 0.6).CGColor;
    self.collectionView.layer.cornerRadius = 10.0f;
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TrainCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"TrainCollectionCell"];
}

- (VIPBuyView *)vipBuy {
    if (!_vipBuy) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VIPBuyView" owner:self options:nil];
        if (array.count>0) {
            _vipBuy = array[0];
            _vipBuy.frame = CGRectMake(60, -370, screenwidth-120, (screenwidth-120)*291/526);
            _vipBuy.layer.masksToBounds = YES;
            _vipBuy.layer.cornerRadius = 5.0f;
            weakify(self);
            _vipBuy.callBackCancelButton = ^(){
                //VIP取消按钮点击
                [weakSelf hide];
            };
            _vipBuy.callBackBuyButton = ^(){
                //VIP确定按钮点击
                [SVProgressHUD showWithStatus:@"功能尚在开放中..."];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            };
        }
    }
    return _vipBuy;
}

- (UIView *)popBackView {
    if (!_popBackView) {
        _popBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
        _popBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UITapGestureRecognizer *gesTure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        gesTure.delegate = self;
        [_popBackView addGestureRecognizer:gesTure];
    }
    return _popBackView;
}
@end
