//
//  BaiDuMapViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/8.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "BaiDuMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>
@interface BaiDuMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>{
    
    BMKMapView *_mkMapView;
    BMKLocationService *_locationService;
}

@end

@implementation BaiDuMapViewController

-(void)viewWillAppear:(BOOL)animated {
    //[_mkMapView viewWillAppear];
   // _mkMapView.delegate = self;
}

-(void)viewDidLoad {
    
    self.title = @"位置";
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:self
//                                                                  action:@selector(returnBack)
//                                   ];
//    self.navigationItem.leftBarButtonItem = leftButton;
//    

    if(_mkMapView == nil){
        _mkMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _mkMapView.mapType = BMKMapTypeStandard;
        _mkMapView.zoomEnabled = YES;
        _mkMapView.scrollEnabled = YES;
        _mkMapView.showsUserLocation = YES;
        _mkMapView.delegate =self;
        [self.view addSubview:_mkMapView];
    }
    
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    [BMKLocationService setLocationDistanceFilter:1000.0];
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationService startUserLocationService];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude =  [_latitude doubleValue];
    coordinate.longitude = [_logitute doubleValue];
    NSLog(@"latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude);
    
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(1.0, 1.0));
    BMKCoordinateRegion adjustedView = [_mkMapView  regionThatFits:region];
    [_mkMapView setRegion:adjustedView];
    [_mkMapView setZoomLevel:16];
    [_mkMapView setZoomEnabledWithTap:YES];
    [_mkMapView setUserInteractionEnabled:YES];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = _address;
    [_mkMapView addAnnotation:annotation]; 
    

}

-(void)returnBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"Dismissed");
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [_mkMapView viewWillDisappear];
    _mkMapView.delegate = nil;
}

-(void)dealloc{
    
    _mkMapView.delegate = nil;
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if([annotation isKindOfClass:[BMKPinAnnotationView class]]){
        BMKPinAnnotationView *newAnnotaionView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"baiduAnnotatio"];
        newAnnotaionView.canShowCallout = YES;
        newAnnotaionView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotaionView.animatesDrop = YES;
        return newAnnotaionView;
        
    }
    return nil;
}


-(void)didStopLocatingUser{
    
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"%@",userLocation.description);
}
-(void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"%@",error);
}
@end
