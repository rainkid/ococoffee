//
//  TipView.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/1.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipView : UIView

+(void)displayView:(UIView *)view withFrame:(CGRect)rect withString:(NSString *)msg ;

+(void)hiddenTheView:(NSTimer *)timer;
@end
