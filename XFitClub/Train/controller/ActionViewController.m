//
//  ActionViewController.m
//  XFitClub
//
//  Created by 郭炜 on 2017/4/20.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "ActionViewController.h"
#import "Header.h"
#import "TagView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ActionViewController ()<AVPlayerViewControllerDelegate> {
    NSString *videoUrl;
    AVPlayerViewController *movie;
}
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *actImageView;
@property (weak, nonatomic) IBOutlet UILabel *actName;
@property (weak, nonatomic) IBOutlet UIView *tagViews;
@property (weak, nonatomic) IBOutlet UITextView *actDetail;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithNavBar];
    [self initWithDataSource];
}

- (void)initWithNavBar {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screenwidth, 44)];
    navView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [self.view addSubview:navView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 7, 30, 30);
    [backButton setTitle:@"<" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:29];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [navView addSubview:backButton];
}
#pragma mark - 数据
- (void)initWithDataSource {
    //请求数据
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,actdetail];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"actId"] = self.actid;
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
            @try {
                NSDictionary *dic = responseObject[@"data"];
                NSDictionary *actDic = dic[@"act"];
                [self.actImageView sd_setImageWithURL:[NSURL URLWithString:actDic[@"act_img"]] placeholderImage:[UIImage imageNamed:@"train_actionIcon"]];
                self.actName.text = [NSString stringWithFormat:@"%@",actDic[@"act_name"]];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenwidth*444/750)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",actDic[@"img1"]]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload];
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
                [imageView addGestureRecognizer:gesture];
                [self.videoView addSubview:imageView];
                //设置tagviews
                videoUrl = actDic[@"act_url"];
                [self configTagViewWithTagArray:actDic[@"tag"]];
                self.actDetail.text = [NSString stringWithFormat:@"%@",actDic[@"introduction"]];
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

- (void)configTagViewWithTagArray:(NSArray *)tagArray {
    TagView *tagView = [[TagView alloc] initWithFrame:CGRectMake(0, 0, screenwidth-56, 50)];
    [self.tagViews addSubview:tagView];
    tagView.types = tagArray;
    CGRect hotSearchFrame = self.tagViews.frame;
    hotSearchFrame.size.height = tagView.frame.size.height+40+10;
    self.tagViews.frame = hotSearchFrame;
}
#pragma mark - 事件
- (IBAction)goPinlun:(id)sender {
    //参与评论
    
}
- (IBAction)seeMorePinlun:(id)sender {
    //查看更多评论
    
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

- (void)tapImage {
    //点击图片 播放视频
    if (videoUrl.length>0) {
        //播放
        NSURL *movieUrl = [[NSURL alloc] initWithString:videoUrl];
        // 1、获取本地资源地址
        // 2、初始化媒体播放控制器
        if (movie) {
            movie = nil;
        }
        // 3、配置媒体播放控制器
        movie = [[AVPlayerViewController alloc]  init];
        // 设置媒体源数据   *****************可能不支持返回的视频格式 我随便找了个视频 可以播放
        movie.player = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://v.jxvdy.com/sendfile/Ei7rWY-6_TqWOLN2vg_MdnDbeasYg5qE5I51veTkML18UCDSKixfPdUusEyvnI0BVqiqJ412uHck_QV0OFKkdhMWZZZHTA"]];
        // 设置拉伸模式
        movie.videoGravity = AVLayerVideoGravityResizeAspect;
        // 设置是否显示媒体播放组件
        movie.showsPlaybackControls = YES;
        // 设置大力
        movie.delegate = self;
        // 播放视频
        [movie.player play];
        // 设置媒体播放器视图大小
        movie.view.bounds = CGRectMake(0, 0, 350, 300);
        movie.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), 64 + CGRectGetMidY(movie.view.bounds) + 30);
        // 4、推送播放
        // 推送至媒体播放器进行播放
         [self presentViewController:movie animated:YES completion:nil];

    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
@end
