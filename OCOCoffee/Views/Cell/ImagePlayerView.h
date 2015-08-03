//
//  ImagePlayerView.h
//  ococoffee
//
//  Created by sam on 15/7/24.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePlayerViewDelegate

-(void)clickedBanner:(long)index;

@end

@interface ImagePlayerView : UIView

@property (nonatomic, assign) id<ImagePlayerViewDelegate> delegate;

@end
