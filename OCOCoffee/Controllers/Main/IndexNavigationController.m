//
//  IndexNavigationController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/14.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "IndexNavigationController.h"

@interface IndexNavigationController ()

@end

@implementation IndexNavigationController

+(void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[IndexNavigationController class], nil];
    
    if([navBar respondsToSelector:@selector(setBackgroundColor:)]){
        [navBar setBackgroundColor:[UIColor colorWithRed:241.0f/255.0f green:95.0f/255.0f blue:117.0f/255.0f alpha:1]];
    }
   // navBar.tintColor= [UIColor redColor];
    
    if([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [navBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeZero];
    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSShadowAttributeName:shadow};
    [navBar setTitleTextAttributes:dict];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
