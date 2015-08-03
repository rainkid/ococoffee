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
#import "TestViewController.h"

@interface AppDelegate (){

    UINavigationController *_activityNavController;
    UINavigationController *_centerNavController;
    UINavigationController *_messageNavController;
    UINavigationController *_testNavController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    UIImage *imageNormal;
    UIImage *imageSelected;
    
    imageNormal       = [UIImage imageNamed:@"singleicon"];
    imageSelected     = [UIImage imageNamed:@"doubleicon"];
    _rootViewController = [[RootViewController alloc] init];
    _rootViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:imageNormal selectedImage:imageSelected];
    
    imageNormal       = [UIImage imageNamed:@"doubleicon"];
    imageSelected     = [UIImage imageNamed:@"singleicon"];
    _messageViewController = [[MessageViewController alloc] init];
    _messageViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:imageNormal selectedImage:imageSelected];
    //_messageViewController.tabBarItem.badgeValue = @"10";
    _messageNavController = [[UINavigationController alloc] initWithRootViewController:_messageViewController];
    
    imageNormal       = [UIImage imageNamed:@"clockicon"];
    imageSelected     = [UIImage imageNamed:@"dependenticon"];
    _activityViewController = [[ActivityViewController alloc] init];
    _activityViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"活动" image:imageNormal selectedImage:imageSelected];
    _activityNavController = [[UINavigationController alloc] initWithRootViewController:_activityViewController];
    
    imageNormal       = [UIImage imageNamed:@"dependenticon"];
    imageSelected     = [UIImage imageNamed:@"clockicon"];
    _centerViewController = [[CenterViewController alloc] init];
    _centerViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:imageNormal selectedImage:imageSelected];
    _centerNavController = [[UINavigationController alloc] initWithRootViewController:_centerViewController];
    
    imageNormal       = [UIImage imageNamed:@"dependenticon"];
    imageSelected     = [UIImage imageNamed:@"clockicon"];
    _testViewController = [[TestViewController alloc] init];
    _testViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"登录" image:imageNormal selectedImage:imageSelected];
    _testNavController = [[UINavigationController alloc] initWithRootViewController:_testViewController];

    
    UITabBarController *_tabBarController = [[UITabBarController alloc] init];
    _tabBarController.delegate = self;
    _tabBarController.viewControllers = @[_rootViewController,_messageNavController,_activityNavController,_centerNavController, _testNavController];
    
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
