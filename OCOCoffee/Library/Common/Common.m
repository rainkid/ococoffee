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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒"
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

+(void)userLogOut
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray  *tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in tmpArray) {
        [cookieJar deleteCookie:obj];
    }
    
}


+(void) shareUserCookie
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:API_DOMAIN]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:USERCOOKIE];
}

//时间格式化
+(NSString *)formatedDateString:(NSDate *)date format:(NSString *)format {
    NSString *dateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = format;
    dateString = [dateFormatter  stringFromDate:date];
    return dateString;
}
@end
