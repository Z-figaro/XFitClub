//
//  APIManager.h
//  XFitClub
//
//  Created by 张鹏 on 2017/3/27.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define ShareNetManager [APIManager sharedManager]



/**定义请求成功的block*/
typedef void(^requestSuccess)( NSDictionary * object);

/**定义请求失败的block*/
typedef void(^requestFailure)( NSError *error);

/**定义上传进度block*/
typedef void(^uploadProgress)(float progress);

/**定义下载进度block*/
typedef void(^downloadProgress)(float progress);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

@interface APIManager : AFHTTPSessionManager

//单例方法
+ (instancetype)sharedManager;


/**
 基本方法

 @param method  选择方法
 @param path    url地址
 @param params  请求参数
 @param success 成功执行
 @param failure 失败执行
 */
- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(void (^)(id responseObject))success
          WithFailurBlock:(void (^)(NSError *error))failure;

/**
 *  上传图片
 *
 *  @param operations   上传图片预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @parm width      图片要被压缩到的宽度
 *  @param urlString    上传的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 */

+(void)uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withtargetWidth:(CGFloat )width withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailurBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress;

/**
 下载图片

 @param imageView         下载图片的视图
 @param oringinalImageUrl 原始图片
 @param thumbnailImageURL 缩略图
 @param placeholderImage  占位图片
 @param completedBlock    完成回调
 */
+ (void)ZPP_imageView:(UIImageView *)imageView ImageWithOringinalImageURL:(NSString *)oringinalImageUrl thumbnailImageURL:(NSString *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage completed:(SDWebImageCompletionBlock)completedBlock;
/**
 *  视频上传
 *
 *  @param operations   上传视频预留参数---视具体情况而定 可移除
 *  @param videoPath    上传视频的本地沙河路径
 *  @param urlString     上传的url
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 *  @param progress     上传的进度
 */
+(void)uploadVideoWithOperaitons:(NSDictionary *)operations withVideoPath:(NSString *)videoPath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withUploadProgress:(uploadProgress)progress;


/**
 *  文件下载
 *
 *  @param operations   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param urlString        请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */


+(void)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withDownLoadProgress:(downloadProgress)progress;

/**
 *  取消所有的网络请求
 */


+(void)cancelAllRequest;
/**
 *  取消指定的url请求
 *
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的url
 */

+(void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string;
@end
