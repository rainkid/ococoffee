//
//  CycleBannerView.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/28.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "CycleBannerView.h"


@implementation CycleBannerView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        _bannerView = [[KDCycleBannerView alloc] initWithFrame:self.bounds];
        _bannerView.backgroundColor = [UIColor redColor];
        _bannerView.delegate = self;
        _bannerView.datasource = self;
        _bannerView.continuous = YES;
        _bannerView.autoPlayTimeInterval = 3;
        [self addSubview:_bannerView];
    }
    
    return self;
}

-(NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView{
    return _bannerArray;
}

-(UIViewContentMode)contentModeForImageIndex:(NSUInteger)index
{
    return UIViewContentModeScaleAspectFill;
}


@end
