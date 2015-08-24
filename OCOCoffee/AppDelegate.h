//
//  AppDelegate.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/23.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexViewController;
@class ActivityViewController;
@class CenterViewController;
@class MessageViewController;

@interface AppDelegate : UIResponder

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *mainController;

@property(strong,nonatomic) IndexViewController *indexViewController;
@property(strong,nonatomic) MessageViewController *messageViewController;
@property(strong,nonatomic) ActivityViewController *activityViewController;
@property(strong,nonatomic) CenterViewController *centerViewController;


@end

