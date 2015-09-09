//
//  BaiDuMapViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/8.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "BaiDuMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>


@interface BaiDuMapViewController ()<BMKMapViewDelegate>{
    
    BMKMapView *_mkMapView;
}

@end

@implementation BaiDuMapViewController


-(void)viewDidLoad {
    
    _mkMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mkMapView.delegate = self;
    _mkMapView.mapType = BMKMapTypeStandard;
    [self.view addSubview:_mkMapView];
    
}


-(void)viewDidAppear:(BOOL)animated {
    _mkMapView.delegate = nil;
}

-(void)dealloc{
    
    _mkMapView.delegate = nil;
}



@end
