//
//  TipView.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/1.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "TipView.h"

@implementation TipView


+(void)displayView:(UIView *)view withFrame:(CGRect)rect withString:(NSString *)msg {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:3.0f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:2.0f];
    
    UIView *displayView = [[UIView alloc] initWithFrame:rect];
    displayView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc ] init];
    label.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    label.backgroundColor = [UIColor grayColor];
    label.text = msg;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    [displayView addSubview:label];
    [view addSubview:displayView];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(hiddenTheView:)
                                   userInfo:displayView
                                    repeats:NO];
    
}

+(void)hiddenTheView:(NSTimer *)timer {
    UIView *theView = (UIView *)[timer userInfo];
    [UIView animateWithDuration:0.8
                     animations:^(void){
                         
                         CGContextRef context = UIGraphicsGetCurrentContext();
                         [UIView beginAnimations:nil context:context];
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationDuration:1.0f];
                         
                         theView.frame = CGRectMake(theView.frame.origin.x,theView.frame.size.height, theView.frame.size.width, theView.frame.size.width);
                         
                         [UIView commitAnimations];
                     }completion:^(BOOL isfinished){
                         [theView removeFromSuperview];
                     }
     ];
}

@end
