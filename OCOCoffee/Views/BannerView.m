//
//  BannerView.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/6.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "BannerView.h"

@interface BannerView ()<KDCycleBannerViewDelegate,KDCycleBannerViewDataource>
    
@property (nonatomic, strong) KDCycleBannerView *cycleBannerView;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *bannerImageArray;

@end

@implementation BannerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self =[super initWithFrame:frame]){
        _cycleBannerView = [[KDCycleBannerView alloc] initWithFrame:self.bounds];
        _cycleBannerView.delegate = self;
        _cycleBannerView.datasource = self;
        _cycleBannerView.autoPlayTimeInterval = 3;
        [self addSubview:_cycleBannerView];
    }
    return self;
}

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView{
    return self.bannerImageArray;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index{
    return UIViewContentModeScaleToFill;
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedBanner:)]) {
        [self.delegate clickedBanner:self.bannerArray[index]];
    }
}

- (void)forceRefresh:(NSArray *)adArray{
    self.bannerArray = adArray;
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:self.bannerArray.count];
    for (NSDictionary *dict in adArray) {
        [imageArray addObject:dict[@"img"]];
    }
    self.bannerImageArray = imageArray;
    if (self.bannerImageArray.count> 1) {
        _cycleBannerView.continuous = YES;
        _cycleBannerView.autoPlayTimeInterval = kAutoPlayTimeInterval;
    }else{
        _cycleBannerView.continuous = NO;
        _cycleBannerView.autoPlayTimeInterval = -1;
    }
    
    [self.cycleBannerView reloadDataWithCompleteBlock:^{
        
    }];
}


@end
