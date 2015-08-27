//
//  Common.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Common : NSObject

+(void)showErrorDialog:(NSString *)errorMsg;
+(bool)userIsLogin;
+(void)userLogOut;
+(void)shareUserCookie;

@end
