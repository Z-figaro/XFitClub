//
//  homeDetailViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/9.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "homeDetailViewController.h"
#import "userCenterViewController.h"
#import "Header.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface homeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userCenterView;//用户中心页面
@property (weak, nonatomic) IBOutlet UIImageView *userSexIcon;//性别头像
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;//地点文字
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImage;//用户头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;//用户名字
@property (strong, nonatomic) IBOutlet UIImageView *fitLevelImageView;
@property (nonatomic, strong) NSString *fitLevelString;
@property (strong, nonatomic) IBOutlet UIView *fitLevelView;//生涯view
@property (strong, nonatomic) IBOutlet UIView *fitNumberView;//混合运动能力值页面
@property (strong, nonatomic) IBOutlet UIView *fitActionView;//参与总数
@property (strong, nonatomic) IBOutlet UIButton *videoButton;
@property (strong, nonatomic) IBOutlet UIButton *activityButton;
@property (strong, nonatomic) IBOutlet UIButton *moneyButton;
@property (strong, nonatomic) IBOutlet UILabel *fitMixNumberLabel;//混合运动能力值
@property (strong, nonatomic) IBOutlet UILabel *fitActionSum;//参与总数
@property (strong, nonatomic) IBOutlet UILabel *DidActionNumberLabel;//完成动作总个数
@property (strong, nonatomic) IBOutlet UILabel *wasteTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *calorieLabel;
@property (strong, nonatomic) IBOutlet UILabel *fans;
@property (strong, nonatomic) IBOutlet UILabel *attentionNumber;

@property (nonatomic, strong) NSString *userSexString;
@property (nonatomic, strong) NSString *userHeadString;//头像url
@property (nonatomic, strong) NSString *userHeightString;
@property (nonatomic, strong) NSString *userWeightString;
@property (nonatomic, strong) NSString *userBirthdayString;
@property (nonatomic, strong) NSString *userLocationString;


- (void)initUserInterface;/**< 初始化用户界面 */
- (void)initDataSource;/**< 初始化数据源 */
@end

@implementation homeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
}
- (void)viewWillAppear:(BOOL)animated{
    
    [self initDataSource];
    [self initUserInterface];
    
    [super viewWillAppear:animated];
    
}
#pragma mark - Init methods
- (void)initDataSource{
    //请求数据
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,homeURL];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"memberId"] = [ShareUserModel getUserMemberID] ;
    params[@"tokenId"] = [ShareUserModel getToken];
    NSLog(@"params == %@",params);
    
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
            
            _fitActionSum.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"acts"]];
            _fans.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"fensi"]];
            _attentionNumber.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"guanzhu"]];
            _calorieLabel.text = responseObject[@"data"][@"kll"];
            _wasteTimeLabel.text = [self TimeformatFromSeconds:[responseObject[@"data"][@"time"] integerValue]];
            _DidActionNumberLabel.text = responseObject[@"data"][@"total"];
            _fitMixNumberLabel.text = responseObject[@"data"][@"yundong_number"];
            _userNameLabel.text = responseObject[@"data"][@"member_name"];
            
            //赋值
            _fitLevelString = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lv"]];
            _userSexString = responseObject[@"data"][@"member_sex"];
            _userHeadString = [NSString stringWithString:responseObject[@"data"][@"portrait_url"]];
            
            
            //拿到用户头像
            UIImage *placeholder = [UIImage imageNamed:@"register_camera"];
            //根据网络状态下载图片
            [_userAvatarImage sd_setImageWithURL:[NSURL URLWithString:_userHeadString] placeholderImage:placeholder];
            
            //性别
            [self addUserSex];
            [self addFitLevel];
            
            
        
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } WithFailurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }];
    
   
}
- (void)initUserInterface{
    
    [self addUserAvatarView];
    [self addLoaction];
    
    //页面的点击事件
    __weak typeof(self) weakSelf = self;
    //用户页
    [self.userCenterView addActionWithblock:^{
        
        [self performSegueWithIdentifier:@"pushUserCenterView" sender:self];
    }];
    //生涯等级
    [self.fitLevelView addActionWithblock:^{
        [weakSelf performSegueWithIdentifier:@"pushFitLevelView" sender:weakSelf];
    }];
    
    //混合运动能力值
    [_fitNumberView addActionWithblock:^{
        [weakSelf performSegueWithIdentifier:@"pushFitMixNumberView" sender:weakSelf];
    }];
    //参与总数
    [_fitActionView addActionWithblock:^{
        [weakSelf performSegueWithIdentifier:@"pushFitActionNumberView" sender:weakSelf];
    }];
    
    
}

#pragma mark - 用户头像
/**
 添加用户头像
 */
- (void)addUserAvatarView{
    
    //头像
    self.userAvatarImage.layer.cornerRadius = self.userAvatarImage.frame.size.width /2;
    self.userAvatarImage.layer.masksToBounds = YES;
    
}
/**< 用户地址 */
- (void)addLoaction{
    //todo:拿到百度appkey之后做
    
}
/**< 用户生涯等级 */
- (void)addFitLevel{
    NSInteger level;
    level = [_fitLevelString integerValue];
    switch (level) {
        case 1:
            _fitLevelImageView.image = [UIImage imageNamed:@"home_level1"];
            break;
        case 2:
            _fitLevelImageView.image = [UIImage imageNamed:@"home_level2"];
            break;
        case 3:
            _fitLevelImageView.image = [UIImage imageNamed:@"home_level3"];
            break;
            //todo :给了4，5的图片做
//        case 4:
//            <#statements#>
//            break;
//        case 5:
//            <#statements#>
//            break;
            
        default:
            break;
    }
    
}
/**< 用户性别 */
- (void)addUserSex{
    if ([_userSexString isEqualToString:@"1"]) {
        _userSexIcon.image = [UIImage imageNamed:@"home_sex_male"];
    } else {
        _userSexIcon.image = [UIImage imageNamed:@"home_sex_female"];
    }
}
#pragma mark - helpMethod

// 时间转换
-(NSString*)TimeformatFromSeconds:(NSInteger)seconds

{
    
    //format of hour
    
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    
    //format of minute
    
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    
    //format of second
    
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    
    //format of time
    
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}

//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}

@end
