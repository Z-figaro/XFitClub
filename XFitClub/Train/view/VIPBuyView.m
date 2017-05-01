//
//  VIPBuyView.m
//  XFitClub
//
//  Created by 郭炜 on 2017/4/20.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "VIPBuyView.h"

@implementation VIPBuyView

- (IBAction)cancelButtonClick:(id)sender {
    if (self.callBackCancelButton) {
        self.callBackCancelButton();
    }
}

- (IBAction)goBuyVipButtonClick:(id)sender {
    if (self.callBackBuyButton) {
        self.callBackBuyButton();
    }
}
@end
