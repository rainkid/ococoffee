//
//  NSString+Size.m
//  shoppingmall
//
//  Created by ShiYu on 14/12/8.
//  Copyright (c) 2014年 jinli. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithFont:(UIFont *)font width:(CGFloat)width
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: style
                                 };
    CGRect rect  = [self boundingRectWithSize:CGSizeMake(width, 9999.f)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attributes
                                                      context:nil];
    CGSize size = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
    return size;
}

@end
