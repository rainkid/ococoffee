//
//  BannerView.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/6.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "BannerView.h"

@interface BannerView (){
    
    KDCycleBannerView *_cycleBannerView;
    
}

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

-(NSArray*)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    return _bannerList;
}

-(UIViewContentMode)contentModeForImageIndex:(NSUInteger)index
{
    return UIViewContentModeScaleToFill;
}

-(void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
    NSLog(@"Click The Ads");
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedAdAtIndex:)]){
        NSLog(@"广告点击成功!");
    }
}

@end
