//
//  NSString+Additional.h
//  weather
//
//  Created by imac on 13-11-8.
//  Copyright (c) 2013年 Gionee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additional)

- (CGSize)measureText:(UIFont *)font andWithWidth:(CGFloat)width;

- (void)drawText:(CGContextRef)context andWithFont:(UIFont *)font andWithFontColor:(UIColor *)fontColor andWithFrame:(CGRect)frame;

@end
