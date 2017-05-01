#import "APIManager.h"

#import "UIImage+compressIMG.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>
#import "Header.h"


@interface APIManager()
@property (strong,nonatomic)APIManager *manager;
@end
@implementation APIManager

+ (instancetype)sharedManager {
    static APIManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
    });
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
#warning 可根据具体情况进行设置
        //断言注意使用
        //         NSAssert(url,@"您需要为您的请求设置baseUrl");
        
        // 请求超时设定
        self.requestSerializer.timeoutInterval = 10;
        // 缓存策略
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        //请求响应的序列化
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        self.responseSerializer = response;
        
        /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        //设置接受类型，现在用的是text/html
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

#pragma mark - get/post

- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(void (^)(id responseObject))success
          WithFailurBlock:(void (^)(NSError *error))failure
{
    switch (method) {
        case GET:{
            _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [self GET:path parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                failure(error);
            }];
            break;
        }
        case POST:{
            _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [self POST:path parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}
#pragma mark - upload image

/**
 *  上传图片
 *
 *  @param operations   上传图片等预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @parm width      图片要被压缩到的宽度
 *  @param urlString    上传的url---请填写完整的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 *
 */

+(void)uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withtargetWidth:(CGFloat )width withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailurBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress;
{
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置接受类型，现在用的是text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    //请求响应的序列化
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger i = 0 ;
        
        /**出于性能考虑,将上传图片进行压缩*/
        for (UIImage * image in imageArray) {
            
            //image的分类方法
            UIImage *  resizedImage =  [UIImage IMGCompressed:image targetWidth:width];
            
            NSData * imgData = UIImageJPEGRepresentation(resizedImage, .5);
            
            //拼接data
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
            
            i++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSLog(@"上传成功:%@",responseObject);
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败:%@",error);
        failureBlock(error);
        
    }];
}

#pragma mark - download image
+ (void)ZPP_imageView:(UIImageView *)imageView ImageWithOringinalImageURL:(NSString *)oringinalImageUrl thumbnailImageURL:(NSString *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage completed:(SDWebImageCompletionBlock)completedBlock{
    
    //查看沙盒中是否有原图，有原图显示原图，没有原图考虑下载
    UIImage *bigImage =[[SDImageCache sharedImageCache]imageFromDiskCacheForKey:oringinalImageUrl];
    if (bigImage) {//有原图
        [imageView sd_setImageWithURL:[NSURL URLWithString:oringinalImageUrl] placeholderImage:placeholderImage completed:completedBlock];
    }else {//没有原图
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        if (manager.reachableViaWiFi) {//wifi,直接加载原图
            [imageView sd_setImageWithURL:[NSURL URLWithString:oringinalImageUrl] placeholderImage:placeholderImage completed:completedBlock];
        }else if (manager.reachableViaWWAN) {//蜂窝网
            BOOL alwaysLoadOriginalSource = YES;
# warning 可以调整用户需求
            if (alwaysLoadOriginalSource) {//用户设置总是加载原图
                [imageView sd_setImageWithURL:[NSURL URLWithString:oringinalImageUrl] placeholderImage:placeholderImage completed:completedBlock];
            }else {//加载略缩图
                [imageView sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholderImage completed:completedBlock];
            }
        }else {//没网有略缩图显示略缩图，没有显示占位图
            
            UIImage *smallImage =[[SDImageCache sharedImageCache]imageFromDiskCacheForKey:thumbnailImageURL];
            if (smallImage) {//有略缩图
                [imageView sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholderImage completed:completedBlock];
            }else {//没有略缩图
                [imageView sd_setImageWithURL:nil placeholderImage:placeholderImage completed:completedBlock];
            }
        }
        
    }
}


#pragma mark - upload video

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

+(void)uploadVideoWithOperaitons:(NSDictionary *)operations withVideoPath:(NSString *)videoPath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withUploadProgress:(uploadProgress)progress
{
    
    
    /**获得视频资源*/
    
    AVURLAsset * avAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath]];
    
    /**压缩*/
    
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    AVAssetExportSession  *  avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
    
    /**创建日期格式化器*/
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /**转化后直接写入Library---caches*/
    
    NSString *  videoWritePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/output-%@.mp4",[formatter stringFromDate:[NSDate date]]]];
    
    
    avAssetExport.outputURL = [NSURL URLWithString:videoWritePath];
    
    
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    
    
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        
        
        switch ([avAssetExport status]) {
                
                
            case AVAssetExportSessionStatusCompleted:
            {
                
                
                
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                //设置接受类型，现在用的是text/html
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
                //请求响应的序列化
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                
                [manager POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    //获得沙盒中的视频内容
                    
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:videoWritePath] name:@"write you want to writre" fileName:videoWritePath mimeType:@"video/mpeg4" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    NSLog(@"上传成功:%@",responseObject);
                    successBlock(responseObject);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"上传失败:%@",error);
                    failureBlock(error);
                    
                }];
                
                break;
            }
            default:
                break;
        }
        
        
    }];
    
}
#pragma mark - 文件下载


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

+(void)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withDownLoadProgress:(downloadProgress)progress
{
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //设置接受类型，现在用的是text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    //请求响应的序列化
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return  [NSURL URLWithString:savePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"上传失败:%@",error);
            failureBlock(error);
        }
        
    }];
    
}


#pragma mark -  取消所有的网络请求

/**
 *  取消所有的网络请求
 *  a finished (or canceled) operation is still given a chance to execute its completion block before it iremoved from the queue.
 */

+(void)cancelAllRequest
{
    
    [ShareNetManager.operationQueue cancelAllOperations];
    
}



#pragma mark -   取消指定的url请求/
/**
 *  取消指定的url请求
 *
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的完整url
 */

+(void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string
{
    
    NSError * error;
    
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    
    NSString * urlToPeCanced = [[[ShareNetManager.requestSerializer requestWithMethod:requestType URLString:string parameters:nil error:&error] URL] path];
    
    
    for (NSOperation * operation in ShareNetManager.operationQueue.operations) {
        
        //如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            //请求的类型匹配
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            //请求的url匹配
            
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            //两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                
                [operation cancel];
                
            }
        }
        
    }
}


@end
