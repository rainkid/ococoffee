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
#import "IndexCollectionView.h"



@interface IndexViewController ()<CLLocationManagerDelegate>
{
    
    CLLocationManager *_locationManager;
    
    double userLogitude;
    double userLatitude;
    
    IndexCollectionView *_collectionView ;
}

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getLocation];
    
    [self getView];
    
    
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


-(void)getView {
    
    _collectionView = [[IndexCollectionView alloc] init];
    _collectionView.items = [self getTestData];
    
    NSLog(@"%@",_collectionView.items);
    
    [self.view addSubview:_collectionView];
    
    
}

-(NSMutableArray *)getTestData {
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0;i< 5;i++){
        [mutableArr addObject:[UIImage imageNamed:@"001.png"]];
        [mutableArr addObject:[UIImage imageNamed:@"002.png"]];
    }
    return mutableArr;
    
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
