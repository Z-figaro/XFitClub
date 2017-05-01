//
//  userModel.m
//  XFitClub
//
//  Created by 张鹏 on 2017/4/16.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "userModel.h"
#import "Header.h"

@implementation userModel
+(userModel *)sharedUserOBJ{
    static dispatch_once_t onceToken;
    static userModel *sharedUserOBJ = nil;
    dispatch_once(&onceToken,^{
        sharedUserOBJ = [[userModel alloc] init];
    });
    return sharedUserOBJ;
}

-(void)getUserInfo{
    //请求数据
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,homeURL];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"memberId"] = [ShareUserModel getUserMemberID] ;
    params[@"tokenId"] = [ShareUserModel getToken];
    NSLog(@"params == %@",params);
    [ShareNetManager requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(id responseObject) {
        if ([responseObject[@"errorcode"] isEqualToString:@"0"]) {
        
            _userAvatarString = [NSString stringWithString:responseObject[@"data"][@"portrait_url"]];
            
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
        }
    } WithFailurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    }];
    
}

@end
