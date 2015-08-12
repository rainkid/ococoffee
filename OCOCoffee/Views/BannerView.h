//
//  BannerView.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/6.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KDCycleBannerView/KDCycleBannerView.h>

@protocol BannerViewDelegate <NSObject>

-(void)clickedAdAtIndex:(NSInteger)index;

@end

@interface BannerView : UICollectionReusableView <KDCycleBannerViewDelegate,KDCycleBannerViewDataource>

@property(nonatomic,assign) id<BannerViewDelegate>delegate;
@property(nonatomic,strong) NSArray *bannerList;

@end
