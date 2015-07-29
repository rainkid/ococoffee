//
//  SeparatorView.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "SeparatorView.h"
#import "UIColor+colorBuild.h"

@interface SeparatorView()


@property (nonatomic, assign) CGFloat startPointX;

@end

@implementation SeparatorView

- (void)setBottomLineStartFromX:(CGFloat)startPointX{
    self.startPointX = startPointX;
}


- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    CGContextSetLineWidth(context, self.frame.size.height);
    CGContextSetStrokeColorWithColor(context,
                                     [UIColor colorFromHexString:@"#D8D8D8"].CGColor);
    
    CGContextMoveToPoint(context, self.startPointX, 0);
    CGContextAddLineToPoint(context,rect.size.width, 0);
    
    CGContextStrokePath(context);
    
}

@end

