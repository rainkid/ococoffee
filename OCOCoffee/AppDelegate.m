//
//  AppDelegate.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/23.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"
#import "IndexViewController.h"
#import "MessageViewController.h"
#import "ActivityViewController.h"
#import "CenterViewController.h"

@interface AppDelegate (){

    UINavigationController *_rootNavController;
    UINavigationController *_activityNavController;
    UINavigationController *_centerNavController;
    UINavigationController *_messageNavController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    UIImage *imageNormal;
    UIImage *imageSelected;
    
    imageNormal       = [UIImage imageNamed:@"home_origin"];
    imageSelected     = [UIImage imageNamed:@"home_clicked"];
    _rootViewController = [[RootViewController alloc] init];
    _rootViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:imageNormal selectedImage:imageSelected];
    
    imageNormal       = [UIImage imageNamed:@"msg_origin"];
    imageSelected     = [UIImage imageNamed:@"msg_clicked"];
    _messageViewController = [[MessageViewController alloc] init];
    _messageViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:imageNormal selectedImage:imageSelected];
    _messageNavController = [[UINavigationController alloc] initWithRootViewController:_messageViewController];
    
    imageNormal       = [UIImage imageNamed:@"schedule_origin"];
    imageSelected     = [UIImage imageNamed:@"schedule_clicked"];
    _activityViewController = [[ActivityViewController alloc] init];
    _activityViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"日程" image:imageNormal selectedImage:imageSelected];
    _activityNavController = [[UINavigationController alloc] initWithRootViewController:_activityViewController];
    
    imageNormal       = [UIImage imageNamed:@"my_origin"];
    imageSelected     = [UIImage imageNamed:@"my_clicked"];
    _centerViewController = [[CenterViewController alloc] init];
    _centerViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:imageNormal selectedImage:imageSelected];
    _centerNavController = [[UINavigationController alloc] initWithRootViewController:_centerViewController];

    
    UITabBarController *_tabBarController = [[UITabBarController alloc] init];
    _tabBarController.delegate = self;
    _tabBarController.viewControllers = @[_rootViewController,_messageNavController,_activityNavController,_centerNavController];
    
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor clearColor]];
    [self.window setRootViewController:_tabBarController];
    [self.window makeKeyAndVisible];
    
    return YES;
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
