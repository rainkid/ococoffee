//
//  BannerView.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/6.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KDCycleBannerView/KDCycleBannerView.h>

static const CGFloat kAutoPlayTimeInterval = 5;

@protocol BannerClickedProtocol <NSObject>

- (void)clickedBanner:(NSDictionary *)dict;

@end

@interface BannerView : UICollectionReusableView

@property (nonatomic, assign) id<BannerClickedProtocol> delegate;

- (void)forceRefresh:(NSArray *)adArray;
@end
