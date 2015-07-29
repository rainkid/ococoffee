//
//  UIColor+colorBuild.h
//  weather
//
//  Created by imac on 13-11-5.
//  Copyright (c) 2013年 Gionee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (colorBuild)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIColor *)colorFromHexString:(NSString *)hexString andWithAlpha:(CGFloat)alpha;

@end
