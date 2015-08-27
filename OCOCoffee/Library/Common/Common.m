//
//  Common.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//
#import "Global.h"
#import "Common.h"

@implementation Common


+(void)showErrorDialog:(NSString *)errorMsg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:errorMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil
                              ];
    [alertView show];
}

#pragma mark check user is login with cookie shared
+(bool)userIsLogin
{
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:USERCOOKIE];
    if ([cookiesdata length] == 0) {
        return false;
    }
    return true;
}
@end
