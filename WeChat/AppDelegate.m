//
//  AppDelegate.m
//  Xmpp--WeChat
//
//  Created by lanouhn on 16/2/27.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPP.h"
#import "WCNavigationController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 打开XMPP日志
    // [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // 设置导航栏主题
    [WCNavigationController setupNavTheme];
    
    /**
     *主要是在每次加载APP之前先从沙盒读取用户数据到单例, 并且在每次登录成功之前都把用户数据写入沙盒
     *从沙里加载用户的数据到单例
     */
    [[WCUserInfo sharedWCUserInfo] loadUserInfoFromSanbox];
    
    // 判断用户的登录状态, 如果是YES代表登陆过, 如果是NO代表没有登录过
    if ([WCUserInfo sharedWCUserInfo].loginStatus) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.window.rootViewController = storyBoard.instantiateInitialViewController;
        
        // 每次关闭应用再次打开之后会断开连接, 所以这里需要在再次进入主界面时自动登录服务器
        [[WCXmppTool sharedWCXmppTool] login:nil];
    }
    
    self.isExistSQLite = [self isExistInFields];
    NSLog(@"%@", NSHomeDirectory());
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSLog(@"%@", path);
    
    return YES;
}

- (BOOL)isExistInFields
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    docsdir = [docsdir stringByAppendingPathComponent:@"Contact/contact.sqlite"];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    BOOL isDir;
    return [filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
