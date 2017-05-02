//
//  AppDelegate.m
//  XFitClub
//
//  Created by 张鹏 on 2017/3/10.
//  Copyright © 2017年 aidspp@163.com. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "ZPPAccountTool.h"
#import "LoginNavigationViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AppDelegate (){
    NSInteger count;
}
@property(strong, nonatomic)NSTimer* mTimer;
@property(assign, nonatomic)UIBackgroundTaskIdentifier backIden;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //计时器
    count=0;
    
    [self startMonitoring];
    //启动页延时
    [NSThread sleepForTimeInterval:3.0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //todo：从登录页面进入
    [self checkUserInfo];
    
   //fix:只在调试UI的时候使用
//    [self testUI];
    
    [self.window makeKeyAndVisible];
    //统一设置提示框
//    [self setProgressHUD];
    return YES;
}

- (void)testUI{
    //没有启动ui，先做主界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarViewController *mainView = [storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    self.window.rootViewController = mainView;
    
}
#pragma mark - app启动进入页面逻辑
- (void)checkUserInfo{
    
   
    // 先判断有无存储账号信息
    if (![[ShareUserModel getUserLogin] isEqualToString:@"login"]) { // 之前没有登录
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        LoginViewController *loginView = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        LoginNavigationViewController *loginView = [storyboard instantiateViewControllerWithIdentifier:@"loginNaviView"];
        self.window.rootViewController = loginView;
        
    } else {// 之前登录成功
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainTabBarViewController *mainView = [storyboard instantiateViewControllerWithIdentifier:@"mainView"];
        self.window.rootViewController = mainView;
    }
}
#pragma mark - 启动网络监控
- (void)startMonitoring{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


#pragma mark - 验证码计时器

//计时
-(void)countAction{
    NSLog(@"%li",(long)count++);
}
//申请后台
-(void)beginTask
{
    NSLog(@"begin=============");
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //在时间到之前会进入这个block，一般是iOS7及以上是3分钟。按照规范，在这里要手动结束后台，你不写也是会结束的（据说会crash）
        NSLog(@"将要挂起=============");
        [self endBack];
    }];
}
//注销后台
-(void)endBack
{
    NSLog(@"end=============");
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}

#pragma mark - 提示框

-(void)setProgressHUD{
    
    [SVProgressHUD appearance];
    
    [SVProgressHUD setBackgroundLayerColor:[UIColor redColor]];
    
   
}











- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    _mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_mTimer forMode:NSRunLoopCommonModes];
    [self beginTask];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"进入前台");
    [self endBack];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"XFitClub"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



@end
