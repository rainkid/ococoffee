//
//  IndexViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define BANNERSECTION 0

#import "IndexViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "IndexViewLayout.h"
#import "BannerView.h"
#import "IndexCollectionViewCell.h"
#import "CenterViewController.h"

static NSString *kCycleBannerIdentifier= @"kbannerIdentifier";
static NSString *kIndexCollectionIdentifier = @"kindexCellIdentifier";
@interface IndexViewController ()<CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource> {
    
    CLLocationManager *_locationManager;
    BannerView *_bannerView;
    double userLogitude;
    double userLatitude;
}
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   // self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
   // [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
//    UIImageView *titleImageView = [[UIImageView alloc] init];
//    titleImageView.image  = [UIImage imageNamed:@"location"];
//    self.navigationController.navigationItem.titleView = titleImageView;
//
    
//    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
//        NSLog(@"set bar tint color");
//        
//        [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
//    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, -20)];
    view.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:95.0f/255.0f blue:117.0f/255.0f alpha:1];

    [self.navigationController.navigationBar addSubview:view];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundColor:)]){
        NSLog(@"set background color");
        [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:211.0f/255.0f green:95.0f/255.0f blue:117.0f/255.0f alpha:1]];
    }
    
//    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
//    }
    
    UIImageView *titleView = [[UIImageView alloc] init];
    titleView.image = [UIImage imageNamed:@"title"];
    if([self.navigationController.navigationItem respondsToSelector:@selector(setTitleView:)]){
        NSLog(@"set title view");
        [self.navigationController.navigationItem setTitleView:titleView];
    }
    
    
    if(_collectionView == nil){
        UICollectionViewFlowLayout *indexLayout = [[UICollectionViewFlowLayout alloc] init];
        indexLayout.minimumInteritemSpacing = 2.0;
        indexLayout.minimumLineSpacing = 2.0;
        indexLayout.sectionInset = UIEdgeInsetsMake(2, 2, 3, 3);
        indexLayout.itemSize  =self.view.bounds.size;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:indexLayout];
        _collectionView.delegate  = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.scrollsToTop = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[BannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCycleBannerIdentifier];
        [_collectionView registerClass:[IndexCollectionViewCell class] forCellWithReuseIdentifier:kIndexCollectionIdentifier];
        [self.view addSubview:_collectionView];
    }
    
    _dataList = [[NSMutableArray alloc] initWithCapacity:0];
    
   }

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIndexCollectionIdentifier forIndexPath:indexPath];
   //UIImage *image = [_dataList objectAtIndex:[indexPath row]];
    cell.userImageView.image = [UIImage imageNamed:@"img2.png"];
    cell.usernameLabel.text = @"文胆剑心";
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/2 -5 , 270);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, 65);
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == BANNERSECTION){
        if(_bannerView == nil){
            _bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCycleBannerIdentifier forIndexPath:indexPath];
           // _bannerView.delegate = self;
            _bannerView.bannerList = [[NSArray alloc] initWithObjects:
                                      [UIImage imageNamed:@"img1.png"],
                                      [UIImage imageNamed:@"img2.png"],
                                      [UIImage imageNamed:@"img2.png"],
                                      nil];
           
        }
         return _bannerView;
    }
    
    return [UICollectionReusableView new];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld-- %ld",indexPath.section,indexPath.row);
    CenterViewController *centerViewController = [[CenterViewController alloc] init];
    [self.navigationController pushViewController:centerViewController animated:YES];
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
