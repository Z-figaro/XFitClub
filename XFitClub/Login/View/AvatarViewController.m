//
//  AvatarViewController.m
//  XFitClub
//
//  Created by figaro on 2017/3/27.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "AvatarViewController.h"
#import "ZPPAccountTool.h"

@interface AvatarViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *avatarNextButton;
@end

@implementation AvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAvatarView];
}

//  方法：设置头像样式
-(void)setAvatarView{
    //  把头像设置成圆形
    // set the view to 正方形就正常了
    self.avatarView.layer.cornerRadius=self.avatarView.frame.size.width/2;//裁成圆角
    self.avatarView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    //  给头像加一个圆形边框
    self.avatarView.layer.borderWidth = 1.5f;//宽度
    self.avatarView.layer.borderColor = [UIColor whiteColor].CGColor;//颜色
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
    _avatarView.image = newPhoto;
    
    NSData *data = UIImagePNGRepresentation(newPhoto);
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [ZPPAccountTool putUserDefaults:str key:@"userAvatar"];
    [picker dismissViewControllerAnimated:YES completion:nil];
   
}
//取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//nextButton
- (IBAction)nextButton:(id)sender {
    
    if (_avatarView == nil) {
         _avatarNextButton.userInteractionEnabled = NO;
    } else {
         _avatarNextButton.userInteractionEnabled = YES;
        [self performSegueWithIdentifier:@"avatarToName"sender:self];
    }
    
}



@end
