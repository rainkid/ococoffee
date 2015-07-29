//
//  AppDelegate.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/23.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class IndexViewController;
@class ActivityViewController;
@class CenterViewController;
@class MessageViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;


@property(strong,nonatomic) RootViewController *rootViewController;
@property(strong,nonatomic) MessageViewController *messageViewController;
@property(strong,nonatomic) ActivityViewController *activityViewController;
@property(strong,nonatomic) CenterViewController *centerViewController;

@end

