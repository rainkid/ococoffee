//
//  Common.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "ViewStyles.h"

@implementation ViewStyles


+(void)setNaviControllerStyle:(UINavigationController *)navController {
    
    [navController.navigationBar setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:94.0/255.0 blue:118.0/255.0 alpha:1.0]];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeZero];
    UIFont* font = [UIFont fontWithName:@"Courier" size:21.0];
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName:[UIColor whiteColor],
                           NSShadowAttributeName:shadow,
                           NSFontAttributeName:font,
                           };
    [navController.navigationBar setTitleTextAttributes:dict];
    [navController.navigationBar setTintColor:[UIColor whiteColor]];
}

@end
