//
//  AppDelegate.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/23.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"
#import "IndexViewController.h"
#import "MessageViewController.h"
#import "ActivityTableViewController.h"
#import "CenterViewController.h"
#import "ViewStyles.h"
#import <BaiduMapAPI/BMapKit.h>

@interface AppDelegate ()<UIApplicationDelegate,UITabBarControllerDelegate>

@property(nonatomic, strong) UINavigationController *indexNavController;
@property(nonatomic, strong) UINavigationController *activityNavController;
@property(nonatomic, strong) UINavigationController *centerNavController;
@property(nonatomic, strong) UINavigationController *messageNavController;

@property(nonatomic,strong) BMKMapManager *manager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UIImage *imageNormal;
    UIImage *imageSelected;
    
    //
    imageNormal       = [UIImage imageNamed:@"home_origin"];
    imageSelected     = [UIImage imageNamed:@"home_clicked"];
    _indexViewController = [[IndexViewController alloc]  initWithNibName:nil bundle:nil];
    _indexViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:imageNormal selectedImage:imageSelected];
    _indexNavController = [[UINavigationController alloc] initWithRootViewController:_indexViewController];
    [ViewStyles setNaviControllerStyle:_indexNavController];
    //
    imageNormal       = [UIImage imageNamed:@"msg_origin"];
    imageSelected     = [UIImage imageNamed:@"msg_clicked"];
    _messageViewController = [[MessageViewController alloc]  initWithNibName:nil bundle:nil];
    _messageViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:imageNormal selectedImage:imageSelected];
    _messageNavController = [[UINavigationController alloc] initWithRootViewController:_messageViewController];
    [ViewStyles setNaviControllerStyle:_messageNavController];
    //
    imageNormal       = [UIImage imageNamed:@"schedule_origin"];
    imageSelected     = [UIImage imageNamed:@"schedule_clicked"];
    _activityViewController = [[ActivityTableViewController alloc]  initWithNibName:nil bundle:nil];
    _activityViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"日程" image:imageNormal selectedImage:imageSelected];
    _activityNavController = [[UINavigationController alloc] initWithRootViewController:_activityViewController];
    [ViewStyles setNaviControllerStyle:_activityNavController];
    //
    imageNormal       = [UIImage imageNamed:@"my_origin"];
    imageSelected     = [UIImage imageNamed:@"my_clicked"];
    _centerViewController = [[CenterViewController alloc] initWithNibName:nil bundle:nil];
    _centerViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:imageNormal selectedImage:imageSelected];
    _centerNavController = [[UINavigationController alloc] initWithRootViewController:_centerViewController];
    [ViewStyles setNaviControllerStyle:_centerNavController];
    //
    _mainController = [[UITabBarController alloc] init];
    _mainController.delegate = self;
    _mainController.viewControllers = @[_indexNavController, _messageNavController, _activityNavController,_centerNavController];
    
    //
    
    _manager = [[BMKMapManager alloc] init];
    BOOL ret = [_manager start:BAIDUKEY generalDelegate:nil];
    if(ret){
        NSLog(@"百度地图服务已开始");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.mainController;
    self.mainController.delegate = self;
    [self.window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [BMKMapView willBackGround];
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
    
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
