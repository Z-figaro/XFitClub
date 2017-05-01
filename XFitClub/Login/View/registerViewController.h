//
//  registerViewController.h
//  XFitClub
//
//  Created by 张鹏 on 2017/3/23.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *checkNumber;
@property (weak, nonatomic) NSString *verificationCode;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;

@end
