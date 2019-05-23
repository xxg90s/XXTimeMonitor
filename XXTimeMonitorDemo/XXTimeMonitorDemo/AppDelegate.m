//
//  AppDelegate.m
//  XXTimeMonitorDemo
//
//  Created by xxg90s on 2019/5/23.
//  Copyright © 2019 AnTuan Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "XXTimeMonitor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [XXTimeMonitor startWithDisplayType:XXTimeMonitorDisplayTypeLog delegate:nil releaseEnable:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupLogSystem];
    [XXTimeMonitor splitTimeWithDescription:@"日志系统"];
    
    [self setupBaiduSdk];
    [XXTimeMonitor splitTimeWithDescription:@"百度SDK"];
    
    [self setupOther];
    [XXTimeMonitor splitTimeWithDescription:@"其他操作"];
    
    ViewController *viewCtl = [[ViewController alloc] init];
    self.window.rootViewController = viewCtl;
    [XXTimeMonitor splitTimeWithDescription:@"首页初始化"];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [XXTimeMonitor splitTimeWithType:XXTimeMonitorTypeContinuous description:@"启动耗时"];
    [XXTimeMonitor stop];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Test
- (void)setupLogSystem {
    int a = 0;
    for (int i = 0; i < 100000000; i++) {
        a += 1;
    }
}

- (void)setupBaiduSdk {
    int a = 0;
    for (int i = 0; i < 1000000; i++) {
        a += 1;
    }
}

- (void)setupOther {
    int a = 0;
    for (int i = 0; i < 500000000; i++) {
        a += 1;
    }
}

@end
