//
//  CycleBannerView.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/28.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KDCycleBannerView/KDCycleBannerView.h>

@interface CycleBannerView : UIView<KDCycleBannerViewDelegate,KDCycleBannerViewDataource>

@property(strong,nonatomic) KDCycleBannerView *bannerView;
@property(strong,nonatomic) NSArray *bannerArray;

@end
