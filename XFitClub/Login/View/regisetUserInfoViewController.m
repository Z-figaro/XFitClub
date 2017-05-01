//
//  regisetUserInfoViewController.m
//  XFitClub
//
//  Created by 张鹏 on 2017/4/9.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "regisetUserInfoViewController.h"
#import "Header.h"
#import "MOFSPickerManager.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "userInfoViewController.h"

@interface regisetUserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *userAvatarImage;
@property (strong, nonatomic) IBOutlet ZPPTextField *userNameText;
@property (strong, nonatomic) IBOutlet UIButton *manButton;
@property (strong, nonatomic) IBOutlet UIButton *femaleButton;
@property (strong, nonatomic) IBOutlet UIButton *gotoNextViewButton;
@property (strong, nonatomic) IBOutlet UIView *chooseAvatarView;
@property (weak, nonatomic) IBOutlet UIButton *heightButton;
@property (weak, nonatomic) IBOutlet UIButton *WeightButton;
@property (weak, nonatomic) IBOutlet UIButton *BrithdayButton;

@property (nonatomic, strong) UIImage *userSelectedImage; //用户头像传值使用


@end

@implementation regisetUserInfoViewController
//选择头像用
bool show = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAvatarView];
    [self userNameMethod];
    [self userSexMethod];
    
    //移走选择头像
    [_chooseAvatarView setBounds:CGRectMake(500, 0, 0, 0)];
    
    
    
}
#pragma mark - 跳转到信息完成页面

- (IBAction)gotoNextViewButton:(id)sender {
    //填写了所有信息之后跳转
    if ([_userNameText.text isEqualToString:@""]) {
       
        [SVProgressHUD showErrorWithStatus:@"请输入名字"];
       
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
       return;
    }
   else if (_userSelectedImage == nil) {
     
       [SVProgressHUD showErrorWithStatus:@"请选择头像"];
       [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
       return;
    }
   else if ([ShareUserModel getUserSex] == nil) {
    
       [SVProgressHUD showErrorWithStatus:@"请选择性别"];
       [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
       return;
    }
   else if ([_heightButton.titleLabel.text isEqualToString:@"身高"]) {
              [SVProgressHUD showErrorWithStatus:@"请输入身高"];
       [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
       return;
    }
   else if ([_WeightButton.titleLabel.text isEqualToString:@"体重"]) {
       
       [SVProgressHUD showErrorWithStatus:@"请输入体重"];
       [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
       return;
    }
   else if ([_BrithdayButton.titleLabel.text isEqualToString:@"出生日期"]) {
      
       [SVProgressHUD showErrorWithStatus:@"请输入生日"];
       [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
       return;
    }
   else{
        _gotoNextViewButton.userInteractionEnabled = YES;
       [self performSegueWithIdentifier:@"pushRegisterDone"sender:self];
       
   }

}

#pragma mark - 头像选择
//  方法：设置头像样式
-(void)setAvatarView{
    //  把头像设置成圆形
    // set the view to 正方形就正常了
    self.userAvatarImage.layer.cornerRadius  = 48;//裁成圆角
    self.userAvatarImage.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    
    //  给头像加一个圆形边框
    self.userAvatarImage.layer.borderWidth = 1.5f;//宽度
    self.userAvatarImage.layer.borderColor = [UIColor whiteColor].CGColor;//颜色
    
    //头像选择获取方法
    _userAvatarImage.userInteractionEnabled = YES;
    _userAvatarImage.clipsToBounds = YES;
    UITapGestureRecognizer *tap;
    tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(chooseAvatarAction)];
    [_userAvatarImage addGestureRecognizer:tap];
    
    
}
//选择头像获得方式
- (void)chooseAvatarAction{
    if (!show) {
        
        [UIView animateWithDuration:0.25 animations:^{
            [_chooseAvatarView setBounds:CGRectMake(0, 0, 148, 64)];
        }];
        show = true;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            [_chooseAvatarView setBounds:CGRectMake(500, 0, 0, 0)];
        }];
        show = false;
    }
    
}
//相册按钮
- (IBAction)photoAlbum:(id)sender {
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
    PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //允许编辑，即放大裁剪
    PickerImage.allowsEditing = YES;
    //自代理
    PickerImage.delegate = self;
    
    //页面跳转
    [self presentViewController:PickerImage animated:YES completion:nil];
}
//拍照按钮
- (IBAction)takePictures:(id)sender {
    /**
     其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
     */
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
    //获取方式:通过相机
    PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    PickerImage.allowsEditing = YES;
    PickerImage.delegate = self;
    [self presentViewController:PickerImage animated:YES completion:nil];
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _userAvatarImage.image = newPhoto;
    
    NSData *data = UIImagePNGRepresentation(newPhoto);
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    
    //判断是否是当前图片
    if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        //选择到的原始图片
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        _userSelectedImage = originalImage;
        //头像上传
        //数据准备
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,uploadAvatarURL];
        NSArray *imageArray = [NSArray arrayWithObject:originalImage];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"image"] = str;
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
}
//取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - 昵称

- (void)userNameMethod{
    
    //set textfield delegate
    _userNameText.delegate = self;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == _userNameText) {
        //userName 验证
        if ([checkNumber checkUserName:_userNameText.text]) {
            //todo:用户昵称重复验证
            NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,checkUserNameURL];
            NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
            parmas[@"account"] = _userNameText.text;
            
            [ShareNetManager requestWithMethod:POST WithPath:url WithParams:parmas WithSuccessBlock:^(id responseObject) {
                
                if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
                    
                     [ShareUserModel setUserName:_userNameText.text];
                    
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

    }
    
    return YES;
}
#pragma mark - 用户性别选择

- (void)userSexMethod{
    [SVProgressHUD showWithStatus:@"提示：用户性别注册之后，不能修改！！"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];

    if ([ShareUserModel getUserSex] == nil) {
        
        [self chooseMaleButton:_manButton];
    }
    
}
//服务器要求1男2女，所以就这样洛
- (IBAction)chooseMaleButton:(id)sender {
    
    _manButton.selected = YES;
    _femaleButton.selected = NO;
    [_manButton setImage:[UIImage imageNamed:@"register_man1"] forState:UIControlStateNormal];
    [_femaleButton setImage:[UIImage imageNamed:@"register_woman2"] forState:UIControlStateNormal];
    [ShareUserModel setUserSex:@"1"];
    
}
- (IBAction)chooseFemaleButton:(id)sender {
    
    _manButton.selected = NO;
    _femaleButton.selected = YES;
    [_manButton setImage:[UIImage imageNamed:@"register_man2"] forState:UIControlStateNormal];
    [_femaleButton setImage:[UIImage imageNamed:@"register_woman1"] forState:UIControlStateNormal];
    [ShareUserModel setUserSex:@"2"];
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
        NSString *datastr = [NSString stringWithFormat:@"%ldkg",i];
        [dataArray addObject:datastr];
        
    }
    
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:dataArray tag:1 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
          [_WeightButton setTitle:string forState:UIControlStateNormal];
        NSLog(@"weight = %@",string);
    } cancelBlock:^{
        
    }];
}
- (void)userBrithdayMethod{
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd";
    
    [[MOFSPickerManager shareManger] showDatePickerWithTag:1 commitBlock:^(NSDate *date) {
        [_BrithdayButton setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
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


#pragma mark - 界面间传值

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"pushRegisterDone"]) {
        
        userInfoViewController *userInfoView = segue.destinationViewController;
        
        userInfoView.userHeadImage = _userSelectedImage;
        userInfoView.userNameText = _userNameText.text;
        userInfoView.userHeightText = [_heightButton.titleLabel.text stringByReplacingOccurrencesOfString:@"cm" withString:@""];
        userInfoView.userWeightText = [_WeightButton.titleLabel.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
        userInfoView.userBrithdayText = _BrithdayButton.titleLabel.text;
        
        
    }
}


#pragma mark - help Method
//取消提示器
- (void)dismiss{
    
    [SVProgressHUD dismiss];
    
}
//键盘协议
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 收起键盘
    [self.view endEditing:YES];
}

//- (void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    
//    [IQKeyboardManager sharedManager].enable = NO;
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    
//    [super viewWillDisappear:animated];
//    
//    [IQKeyboardManager sharedManager].enable = YES;
//    
//}

@end
