//
//  HttpTool.m
//  走呗
//
//  Created by 走呗 on 15/10/26.
//  Copyright © 2015年 ZOUBEI. All rights reserved.
//

#import "HttpTool.h"
//#import "Header.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@implementation HttpTool

+ (void)postWithBaseURL:(NSString *)urlString params:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    /**
     *  @brief  检查是否网络畅通
     */
//    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
//    [afNetworkReachabilityManager startMonitoring];
//    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
//     {
//         if (status == AFNetworkReachabilityStatusNotReachable) {
//             [SVProgressHUD showErrorWithStatus:@"请检查网络!"];
//             return ;
//         }else{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
        if ([responseObject[@"ErrorId"] integerValue] == 10002 ) {
            
            [manager.operationQueue cancelAllOperations];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //通知进入登录
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(YES)];
            });
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        //请求结束状态栏隐藏网络活动标志：
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
           }];
         }
//     }];
//    
//    [afNetworkReachabilityManager stopMonitoring];
//}
//json请求
+(void)postWithJsonBaseURL:(NSString *)urlString params:(NSDictionary *)params success:(Success)success failure:(Failure)failure{
    /**
     *  @brief  检查是否网络畅通
     */
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == AFNetworkReachabilityStatusNotReachable) {
             [SVProgressHUD showErrorWithStatus:@"请检查网络!"];
             [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
             return ;
         }else{
             AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
             manager.requestSerializer = [AFJSONRequestSerializer serializer];
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             manager.requestSerializer.timeoutInterval = 15;
             manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
             
             [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 success(responseObject);
                 if ([responseObject[@"ErrorId"] integerValue] == 10002 ) {
                     
                     [manager.operationQueue cancelAllOperations];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         //通知进入登录
                         [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(YES)];
                     });
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error);
                 [SVProgressHUD dismiss];
                 NSLog(@"请求失败==%@",error);
                 //请求结束状态栏隐藏网络活动标志：
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             }];
         }
     }];
    
    [afNetworkReachabilityManager stopMonitoring];

    
}

+ (void)postImgaeWithBaseURL:(NSString *)urlString params:(NSDictionary *)params data:(NSMutableArray *)dataArray success:(Success)success failure:(Failure)failure {
    // 上传图片
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"application/x-www-form-urlencoded",nil];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       
        for (NSData *data in dataArray) {
        
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/png"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//上传图片
+(void)updatePic:(NSData *)data response:(void (^)(id response))callBack
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:
                                    @"http://114.215.180.229:9595/AppFileUpload/SaveFileStream"
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        [formData appendPartWithFileData:data name:@"111" fileName:@"avatar.png" mimeType:@"image/jpeg"];
                                    }
                                    error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]
                                    initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:nil
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                  
                                                                  if (error)
                                                                  {
                                                                      callBack(nil);
                                                                      
                                                                  } else
                                                                  {
                                                                      callBack(responseObject);
                                                                  }
                                                                  
                                                              }];
    [uploadTask resume];
}


@end
