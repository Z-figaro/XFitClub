//
//  HttpTool.h
//  走呗
//
//  Created by 走呗 on 15/10/26.
//  Copyright © 2015年 ZOUBEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^Success)(id responseObject);
typedef void (^Failure)(NSError *error);

@interface HttpTool : NSObject

+ (void)postWithBaseURL:(NSString *)urlString  params:(NSDictionary *)params success:(Success)success failure:(Failure)failure;
+ (void)postImgaeWithBaseURL:(NSString *)urlString params:(NSDictionary *)params data:(NSMutableArray *)dataArray success:(Success)success failure:(Failure)failure;

//+ (void)postWithJsonBaseURL:(NSString *)urlString params:(NSDictionary *)params success:(Success)success failure:(Failure)failure;
+(void)updatePic:(NSData *)data response:(void (^)(id response))callBack
;

@end
