//
//  Golbal.h
//  ococoffee
//
//  Created by sam on 15/7/24.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#ifndef Global_h
#define Global_h

//#define SD_WEBP 1
//#undef DEBUG
///////////////////////////////////////////////////////////////////////////////////////////////////
// Log helpers
#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
#ifndef ELog
#   define ELog(err) {if(err) DLog(@"%@", err)}
#endif
#else
#ifndef DLog
#   define DLog(...)
#endif
#ifndef ELog
#   define ELog(err)
#endif
#endif

// ALog always displays output regardless of the DEBUG setting
#ifndef ALog
#define ALog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);};
#endif

#define CURRENT_LANGUAGE_TABLE  [[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSwtich"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSwtich"]:@"zh-Hans"

///////////////////////////////////////////////////////////////////////////////////////////////////
// Abbrevation
#define appDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))
#define baiduTracker ([BaiduMobStat defaultStat])

///////////////////////////////////////////////////////////////////////////////////////////////////
// Color helpers

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define HSVCOLOR(h,s,v) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]

#define RGBA(r,g,b,a) (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

///////////////////////////////////////////////////////////////////////////////////////////////////
// Device size helpers
/*
 *屏幕宽度
 */
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

/*
 *屏幕高度
 */

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
/*
 * iPhone 屏幕尺寸
 */
#define PHONE_SCREEN_SIZE (CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_STATUSBAR_HEIGHT))

/*
 * iPhone statusbar 高度
 */
#define PHONE_STATUSBAR_HEIGHT 20

/*
 * iPhone 默认导航条高度
 */
#define PHONE_NAVIGATIONBAR_HEIGHT 44




/*
 * iPhone 在显示导航栏时内容区域的高度
 */
#define PHONE_CONTENT_HEIGHT (SCREEN_HEIGHT - PHONE_STATUSBAR_HEIGHT - PHONE_NAVIGATIONBAR_HEIGHT)

/*
 * iPhone 头部高度
 */

#define PHONE_TOP_HEIGHT (PHONE_STATUSBAR_HEIGHT + PHONE_NAVIGATIONBAR_HEIGHT)

/*
 * iPhone 在显示导航栏时内容区域的高度
 */
#define PHONE_CONTENT_HEIGHT (SCREEN_HEIGHT - PHONE_STATUSBAR_HEIGHT - PHONE_NAVIGATIONBAR_HEIGHT)

#define IOS7_CONTENT_OFFSET ([[UIDevice currentDevice] systemVersionNotLowerThan:@"7.0"] ? 64 : 0)

#define IOS7_STATUSBAR_OFFSET ([[UIDevice currentDevice] systemVersionNotLowerThan:@"7.0"] ? 20 : 0)

#define API_DOMAIN @"http://ococoffee.com/"
//#define API_DOMAIN @"http://dahongmao.net/"


#define USERCOOKIE @"CF-USER-COOKIE"

#define BAIDUKEY @"oOWcaFg4bo2oYv4QOVjNbskE"

#define BAIDUSUGGESTION @"http://api.map.baidu.com/place/v2/suggestion/"

#endif
