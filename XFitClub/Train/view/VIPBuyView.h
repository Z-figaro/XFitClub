//
//  VIPBuyView.h
//  XFitClub
//
//  Created by 郭炜 on 2017/4/20.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPBuyView : UIView
@property (nonatomic, copy) void (^callBackCancelButton)(void);
@property (nonatomic, copy) void (^callBackBuyButton)(void);

@end
