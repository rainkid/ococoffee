//
//  IndexViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "IndexViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "IndexContentViewController.h"
#import "BannerView.h"



@interface IndexViewController ()<CLLocationManagerDelegate>
{
    
    CLLocationManager *_locationManager;
    
    double userLogitude;
    double userLatitude;
    IndexContentViewController *_contentViewController;
    
    UIScrollView *_cycleScrollView;
}

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_cycleScrollView == nil){
        _cycleScrollView = [[UIScrollView alloc ] init];
        _cycleScrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 75);
    }
    
    

    _contentViewController = [[IndexContentViewController alloc] init];
    _contentViewController.view.frame= self.view.bounds;
    _contentViewController.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_contentViewController.view];
    
   }

-(void)viewDidAppear:(BOOL)animated
{
   
}





-(void)getLocation {
    _locationManager = [[CLLocationManager alloc] init];
    
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:@"还没有开启定位服务"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil
                                  ];
        [alertView show];
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"请在系统设置中开启定位服务"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil
                              ];
        [alert show];
        
    }else {
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000.0f;
        [_locationManager startUpdatingLocation];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = locations[0];
    userLogitude = currentLocation.coordinate.latitude;
    userLatitude = currentLocation.coordinate.longitude;
    NSLog(@"%f",userLogitude);
    NSLog(@"%f",userLatitude);
    
    [_locationManager stopUpdatingLocation];
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Some Error Has Happened!");
    [_locationManager stopUpdatingLocation];
}



@end
