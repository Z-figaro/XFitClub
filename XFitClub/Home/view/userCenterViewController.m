//
//  userCenterViewController.m
//  XFitClub
//
//  Created by figaro on 2017/4/14.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "userCenterViewController.h"
#import "MainTabBarViewController.h"
#import "Header.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MOFSPickerManager.h"
#import "HeadsPicture.h"

@interface userCenterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userSexIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionNumber;
@property (weak, nonatomic) IBOutlet UILabel *moneyNumber;
@property (weak, nonatomic) IBOutlet UIButton *brithdayButton;
@property (weak, nonatomic) IBOutlet UIButton *heightButton;
@property (weak, nonatomic) IBOutlet UIButton *weightButton;
@property (weak, nonatomic) IBOutlet UILabel *attentionNumber;
@property (weak, nonatomic) IBOutlet UILabel *fansNumber;
@property (weak, nonatomic) IBOutlet ZPPTextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *maleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *femaleImageView;

@property (nonatomic, strong) NSString *userSexString;
@property (nonatomic, strong) NSString *headString;

- (void)initUserInterface;/**< 初始化用户界面 */
- (void)initDataSource;/**< 初始化数据源 */
@end

@implementation userCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self initDataSource];
    [self initUserInterface];
    
}
- (void)changeUserInfo{
    
   //数据准备
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,changeUserInfoURL];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc]init];
    parmas[@"portraiturl"] = [ShareUserModel getUserAvatar];
    parmas[@"account"] = _nameTextField.text;
    parmas[@"birthdate"] = _brithdayButton.titleLabel.text;
    parmas[@"city"] = _userLocationLabel.text;
    parmas[@"height"] = _heightButton.titleLabel.text;
    parmas[@"memberId"] = [ShareUserModel getUserMemberID];
    parmas[@"sex"] = _userSexString;
    parmas[@"tokenId"] = [ShareUserModel getToken];
    parmas[@"weight"] = _weightButton.titleLabel.text;
    
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:parmas WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
            [SVProgressHUD showErrorWithStatus:@"修改成功"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } WithFailurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];

    }];
    
}
#pragma mark - Init methods
- (void)initDataSource{
    
    //数据准备
    NSString *url               = [NSString stringWithFormat:@"%@%@",BaseURL,userCenterURL];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc]init];
    parmas[@"memberId"]         = [ShareUserModel getUserMemberID];
    parmas[@"tokenId"]          = [ShareUserModel getToken];
    NSLog(@"parmas  == %@",parmas);
    //数据请求
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:parmas WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
             _headString = [NSString stringWithString:responseObject[@"data"][@"portrait_url"]];
            //拿到用户头像
            UIImage *placeholder = [UIImage imageNamed:@"register_camera"];
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:_headString] placeholderImage:placeholder];

            _userSexString                  =  responseObject[@"data"][@"member_sex"];
            _userNameLabel.text             =  responseObject[@"data"][@"member_name"];
            _videoNumberLabel.text          =  responseObject[@"data"][@"shipin"];
            _actionNumber.text              =  responseObject[@"data"][@"huodong"];
            _moneyNumber.text               =  responseObject[@"data"][@"money"];
            _brithdayButton.titleLabel.text =  responseObject[@"data"][@"birthdate"];
            [_heightButton setTitle:responseObject[@"data"][@"member_height"] forState:UIControlStateNormal];
            [_weightButton setTitle:responseObject[@"data"][@"member_weight"] forState:UIControlStateNormal];
            _nameTextField.placeholder      =  responseObject[@"data"][@"member_name"];
            _attentionNumber.text           =  [NSString stringWithFormat:@"%@",responseObject[@"data"][@"guanzhu"]];
            _fansNumber.text                =  [NSString stringWithFormat:@"%@",responseObject[@"data"][@"fensi"]];
            
            [self addUserSex];
            //本地保存
            [ShareUserModel setUserID: responseObject[@"data"][@"phone_no"]];
            [ShareUserModel setUserMemberID: responseObject[@"data"][@"member_id"]];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } WithFailurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }];
}
- (void)initUserInterface{
    
    [self addUserAvatarView];
    [self addLoaction];
    

}

#pragma mark - height，Weight，brithday

- (void)userHeightMethod{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    for (NSInteger i=140; i<=240; i++) {
        NSString *datastr = [NSString stringWithFormat:@"%ldcm",(long)i];
        [dataArray addObject:datastr];
    }
    
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:dataArray tag:1 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
        [_heightButton setTitle:string forState:UIControlStateNormal];
        
        NSLog(@"height = %@",string);
        
    } cancelBlock:^{
        
    }];
    
}
- (void)userWeightMethod{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i=30; i<=150; i++) {
        NSString *datastr = [NSString stringWithFormat:@"%ldkg",(long)i];
        [dataArray addObject:datastr];
        
    }
    
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:dataArray tag:1 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
        [_weightButton setTitle:string forState:UIControlStateNormal];
        NSLog(@"weight = %@",string);
    } cancelBlock:^{
        
    }];
}
- (void)userBrithdayMethod{
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd";
    
    [[MOFSPickerManager shareManger] showDatePickerWithTag:1 commitBlock:^(NSDate *date) {
        [_brithdayButton setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        [ShareUserModel setUserBrithday:[df stringFromDate:date]];
    } cancelBlock:^{
        
    }];
}

- (IBAction)height:(id)sender {
    
    [self userHeightMethod];
    
}
- (IBAction)weight:(id)sender {
    [self userWeightMethod];
}

- (IBAction)brithday:(id)sender {
    [self userBrithdayMethod];
}

#pragma mark - sex,avatar,location,name
/**
 添加用户头像
 */
- (void)addUserAvatarView{
    
    //头像
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width /2;
    self.headImageView.layer.masksToBounds = YES;
    
    //头像选择
    [_headImageView addActionWithblock:^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.editing = YES;
        imagePicker.delegate = self;
        /*
         如果这里allowsEditing设置为false，则下面的UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
         应该改为： UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
         也就是改为原图像，而不是编辑后的图像。
         */
        //允许编辑图片
        imagePicker.allowsEditing = YES;
        
        /*
         这里以弹出选择框的形式让用户选择是打开照相机还是图库
         */
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择打开方式" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //取消；
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //通过info字典获取选择的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSData *data   = UIImagePNGRepresentation(image);
    NSString *str  = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //判断是否是当前图片
    if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        //选择到的原始图片
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        //头像上传
        //数据准备
        NSString *url               = [NSString stringWithFormat:@"%@%@",BaseURL,uploadAvatarURL];
        NSArray *imageArray         = [NSArray arrayWithObject:originalImage];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"image"]            = str;
        //上传自定义方法
        [APIManager uploadImageWithOperations:params withImageArray:imageArray withtargetWidth:1 withUrlString:url withSuccessBlock:^(NSDictionary *object) {
            
            if ([[object objectForKey:@"errorcode"]integerValue]==0) {
                //本地保存
                [ShareUserModel setUserAvatar:object[@"data"]];
                [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            } else {
                [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            }
            
            
        } withFailurBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            
        } withUpLoadProgress:^(float progress) {
            
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    //以itemKey为键，将照片存入ImageStore对象中
    [[HeadsPicture sharedHeadsPicture] setImage:image forKey:@"HeadsPicture"];
    //将照片放入UIImageView对象
    self.headImageView.image = image;
    //把一张照片保存到图库中，此时无论是这张照片是照相机拍的还是本身从图库中取出的，都会保存到图库中；
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    //关闭以模态形式显示的UIImagePickerController
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**< 用户地址 */
- (void)addLoaction{
    //todo:拿到百度appkey之后做
    
}
/**< 用户性别 */
- (void)addUserSex{
    if ([_userSexString isEqualToString:@"1"]) {
        _userSexIcon.image     = [UIImage imageNamed:@"home_sex_male"];
        _maleImageView.image   = [UIImage imageNamed:@"register_man1"];
        _femaleImageView.image = [UIImage imageNamed:@"register_woman2"];
        
    } else {
        _userSexIcon.image     = [UIImage imageNamed:@"home_sex_female"];
        _maleImageView.image   = [UIImage imageNamed:@"register_man2"];
        _femaleImageView.image =[UIImage imageNamed:@"register_woman1"] ;
    }
}
/**< 用户名字 */
//- (void)userNameMethod{
//    
//    //set textfield delegate
//    _nameTextField.delegate = self;
//    
//}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
  
        //userName 验证
        if ([checkNumber checkUserName:_nameTextField.text]) {
            //todo:用户昵称重复验证
            NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,checkUserNameURL];
            NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
            parmas[@"account"] = _nameTextField.text;
            
            [ShareNetManager requestWithMethod:POST WithPath:url WithParams:parmas WithSuccessBlock:^(id responseObject) {
                
                if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
                    
                    [ShareUserModel setUserName:_nameTextField.text];
                    
                } else {
                    
                    [SVProgressHUD showErrorWithStatus:@"用户名重复"];
                    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
                }
            } WithFailurBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"用户名重复"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
                
            }];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"请输入20位以内的中文或英文"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
            
        }
        
    
    
    return YES;
}

#pragma mark - 跳转
- (IBAction)backButton:(id)sender {
    
    //跳转到mainView
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarViewController *mainView = [story instantiateViewControllerWithIdentifier:@"mainView"];
    
    [self changeUserInfo];
    [self presentViewController:mainView animated:YES completion:nil];
    
    
}
- (IBAction)userInfoViewControllerUnwindSegue:(UIStoryboardSegue *)segue{
    
}
//跳转到系统页面
- (IBAction)gotoNext:(id)sender {
    
    [self changeUserInfo];
}

//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}
@end
