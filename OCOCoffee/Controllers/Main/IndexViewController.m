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
#import <MJRefresh/MJRefresh.h>

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
    
     __weak __typeof(self) weakSelf = self;
    self.title = @"一杯啡咖";
    
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:94.0/255.0 blue:118.0/255.0 alpha:1.0]];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeZero];
    UIFont* font = [UIFont fontWithName:@"Courier" size:21.0];
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName:[UIColor whiteColor],
                        NSShadowAttributeName:shadow,
                           NSFontAttributeName:font,
                           };
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     
    if(_collectionView == nil){
        UICollectionViewFlowLayout *indexLayout = [[UICollectionViewFlowLayout alloc] init];
        indexLayout.minimumInteritemSpacing = 5.0;
        indexLayout.minimumLineSpacing = 5.0;
        indexLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
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
    
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"Refreshing");
        [weakSelf loadNewData];
    }];
    NSLog(@"begin");
    [_collectionView.header beginRefreshing];
    
    
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^(void){
       
        NSLog(@"Pushing");
        
        for (int i = 0; i< 5; i++) {
            [_dataList addObject:[NSNumber numberWithInt:i]];
        }
        
        [_collectionView reloadData];
        [_collectionView.footer endRefreshing];
    }];
    
    _collectionView.footer.hidden = YES;
    
    _dataList = [[NSMutableArray alloc] initWithCapacity:0];
    
   }


-(void)loadNewData {
    
    for (int i = 0; i<5; i++) {
        [_dataList addObject:[NSNumber numberWithInt:i]];
    }
    
    [_collectionView reloadData];
    [self.collectionView.header endRefreshing];
    
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
    return [_dataList count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIndexCollectionIdentifier forIndexPath:indexPath];
   //UIImage *image = [_dataList objectAtIndex:[indexPath row]];
    int value = (arc4random() % 3) + 1;
   // NSLog(@"%d",value);
    cell.userImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img%d.png",value]];
    cell.usernameLabel.text = @"文胆剑心";
    
    NSInteger tagNumber = [cell.tagCounts integerValue];
    float tagRowHeight = [cell.tagRowHeight floatValue];
    float tagHeight = ((int)(tagNumber / 4 ) + 1 ) *tagRowHeight + 3.00;
    NSLog(@"%f",tagHeight);
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.view.bounds.size.width/2 -10 , 285);
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
