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
#import "Reachability.h"
#import <Masonry/Masonry.h>
#import "UIColor+colorBuild.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

static NSString *base_url = @"http://dahongmao.net/api/index/list";
static NSString *kCycleBannerIdentifier= @"kbannerIdentifier";
static NSString *kIndexCollectionIdentifier = @"kindexCellIdentifier";
@interface IndexViewController ()<CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource> {
    
    UICollectionViewFlowLayout *indexFlowLayout;
    CLLocationManager *_locationManager;
    BannerView *_bannerView;
    Reachability *_reachAblity;
    double logitude;
    double latitude;
    int _curPage;
    int newworkStatus;
    BOOL _hasNextPage;
    NSMutableArray *_columnHeight;
    NSMutableArray *_dataList;
}
@end

@implementation IndexViewController


-(id)init {
    [self getLocation];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     //__weak __typeof(self) weakSelf = self;
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
        indexFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        indexFlowLayout.minimumInteritemSpacing = 5.0;
        indexFlowLayout.minimumLineSpacing = 5.0;
        indexFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        indexFlowLayout.itemSize  =self.view.bounds.size;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:indexFlowLayout];
        _collectionView.delegate  = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.scrollsToTop = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[BannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCycleBannerIdentifier];
        [_collectionView registerClass:[IndexCollectionViewCell class] forCellWithReuseIdentifier:kIndexCollectionIdentifier];
        [self.view addSubview:_collectionView];
        _dataList = [[NSMutableArray alloc] initWithCapacity:0];
        _columnHeight = [[NSMutableArray alloc] initWithCapacity:0];
        _hasNextPage = YES;
        _curPage = 1;
    }
    
    //网络检测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newWorkStateChanged:) name:kReachabilityChangedNotification object:nil];
    _reachAblity = [Reachability reachabilityForInternetConnection];
    [_reachAblity startNotifier];
    newworkStatus = [_reachAblity currentReachabilityStatus];
    
    //刷新加载数据
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        if(newworkStatus == 0){
            [self displayAlertView];
        }
        if(_hasNextPage){
            [self loadNewDataWithPage:_curPage type:@"down"];
        }else {
            [_collectionView.header endRefreshing];
        }
    }];
    
    [_collectionView.header beginRefreshing];
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^(void){
        NSLog(@"Pushing");
        if(newworkStatus == 0){
            [self displayAlertView];
        }
        if(_hasNextPage){
            [self loadNewDataWithPage:_curPage type:@"up"];
        }else{
            NSLog(@"No More Data");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_collectionView.footer noticeNoMoreData];
            });
        }
        [_collectionView reloadData];
        [_collectionView.footer endRefreshing];
    }];
    _collectionView.footer.hidden = YES;
    }

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_reachAblity stopNotifier];
}

-(void)dealloc{
    [_reachAblity stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}


#pragma collection datasource methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataList count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIndexCollectionIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = [_dataList objectAtIndex:[indexPath row]];
    cell.usernameLabel.text     =   dict[@"nickname"];
    cell.constellation.text     =   dict[@"constellation"];
    cell.ageLabel.text          =   [NSString stringWithFormat:@"%@",dict[@"age"]];
    cell.usernameLabel.text     =   dict[@"nickname"];
    cell.locationLabel.text     =   dict[@"distance"];
    cell.timeLabel.text         =   dict[@"last_login_time"];
    if((int)dict[@"sex"] == 1){
        cell.sexImageView.image = [UIImage imageNamed:@"man.png"];
    }else{
        cell.sexImageView.image = [UIImage imageNamed:@"woman.png"];
    }
    NSURL *imageURL = [NSURL URLWithString:dict[@"headimgurl"]];
    [cell.userImageView sd_setImageWithURL:imageURL
                          placeholderImage:[UIImage imageNamed:@"img1"]
                                 completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,NSURL *imageURL){
                                     CGSize newSize = [self getNewImageSize:cell.userImageView.image.size maxSize:cell.contentView.frame.size];
                                     cell.userImageView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
    }];
    NSArray *tags = dict[@"tags"];
    [cell.tagView removeAllTags];
    [self tagView:cell.tagView addTags:tags];
    
// CGSize  newSize = [self getNewImageSize:cell.userImageView.image.size maxSize:cell.contentView.frame.size];
//   cell.userImageView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
//    //NSLog(@"%f",cell.userImageView.frame.size.height);
//    double imageHeight = cell.userImageView.frame.size.height;
//    //cell.userImageView.image = image;
//    [cell.userImageView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.height.mas_equalTo(imageHeight);
//        make.centerX.mas_equalTo(cell.mas_centerX);
//        make.width.mas_equalTo(cell.frame.size.width);
//    }];
//    
//    [cell.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.mas_equalTo(cell.userImageView.mas_bottom).offset(3.0);
//        make.centerX.mas_equalTo(cell.contentView);
//        make.width.mas_equalTo(cell.frame.size.width);
//        make.height.mas_equalTo(@25);
//        
//    }];
//    
//    
//   // NSLog(@"origin_x : %f  origin_y:%f",cell.frame.origin.x,cell.frame.origin.y);
//    NSInteger tagNumber = [cell.tagCounts integerValue];
//    float tagRowHeight = [cell.tagRowHeight floatValue];
//    float tagHeight = ((int)(tagNumber / 4 ) + 1 ) *tagRowHeight + 3.00;
//    
//    
//    float cellHeight = imageHeight + 28 + 25 + tagHeight ;
//    float cellWidth = (self.view.bounds.size.width  - indexFlowLayout.minimumInteritemSpacing *4)/2;
//    float originX = indexFlowLayout.minimumInteritemSpacing + ((indexPath.row) %2)*cellWidth;
//    int column =  ceil( ((double)indexPath.row +1)/2);
//    
//    float originY = 110 + cellHeight * (column-1);
//    //cell.frame = CGRectMake(originX, originY, cellWidth, cellHeight);
//    NSLog(@"column:%d, cell_x:%f,cell_y:%f,cell_w:%f,cell_h:%f",column,originX,originY,cellWidth,cellHeight);
//    //[_columnHeight addObject:<#(id)#>]
//
    return cell;
}


#pragma collection deledate methods 

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width/2 -10 , 285);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, 65);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
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

-(NSArray *)layoutAttributesForElementsInRect {
    return [NSArray new];
}

-(NSMutableArray *)dataList{
    if(_dataList == nil){
        _dataList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataList;
}

-(void)displayAlertView {
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor= [UIColor blackColor];
    alertView.frame = CGRectMake(0, 0, 100, 23);
    alertView.center = self.view.center;
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 23)];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    alertLabel.text = @"网络连接异常";
    alertLabel.textAlignment =NSTextAlignmentCenter;
    [alertView addSubview:alertLabel];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [self.view addSubview:alertView];
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(dismissAlterView:)
                                   userInfo:alertView
                                    repeats:NO];
}

-(void)dismissAlterView:(NSTimer *)timer {
    UIView *alertView = (UIView *)[timer userInfo];
    [alertView removeFromSuperview];
    ///[alertView dismissWithClickedButtonIndex:0 animated:YES];
    alertView = NULL;
}

-(void)newWorkStateChanged:(id)state {
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    Reachability *link = [Reachability reachabilityForInternetConnection];
    if([wifi currentReachabilityStatus] != NotReachable){
        newworkStatus = 2;
    }else if ([link currentReachabilityStatus] != NotReachable){
        newworkStatus = 1;
        NSLog(@"可以使用手机网络上网");
    }else {
        NSLog(@"没有可用网络");
    }
}


//网络加载数据
-(void)loadNewDataWithPage:(int)page  type:(NSString *)type {
    
    [_locationManager startUpdatingLocation];
    double lat = latitude;
    double lng = logitude;
    NSLog(@"%f,%f",lat,lng);
    lat =22.53992;
    lng =114.0201;
  
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    CLGeocoder *gcoder = [[CLGeocoder alloc] init];
    [gcoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks,NSError *error){
        if(!error && [placemarks count]>0){
            CLPlacemark *placeMark = [placemarks firstObject];
           // NSLog(@" distinct:%@ \n address:%@ \n city:%@ \n ",placeMark.name,placeMark.addressDictionary,placeMark.country);
            NSDictionary *dict = placeMark.addressDictionary;
            NSString *detailAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                                       dict[@"State"],dict[@"City"],dict[@"SubLocality"],dict[@"Name"],dict[@"Street"]
                                       ];
           // NSLog(@"%@",detailAddress);
            
        }
    }];

    NSNumber *latitu = [NSNumber numberWithDouble:lat];
    NSNumber *logitu = [NSNumber numberWithDouble:lng];
    NSDictionary *dict = @{@"lat":latitu,@"lng":logitu,@"page":[NSNumber numberWithInt:page]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:base_url parameters:dict success:^(AFHTTPRequestOperation  *operation,id responseObject){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dict = responseObject;
            NSArray *list = dict[@"data"][@"list"];
            
            //下拉刷新时
            if([type  isEqual: @"down"]){
                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [list count])];
                [_dataList insertObjects:list atIndexes:indexes];
            }else{
                [_dataList addObjectsFromArray:list];
            }
            _hasNextPage    = dict[@"hasnext"]?dict[@"hasnext"]:FALSE;
            _curPage        =dict[@"curpage"]? (int)dict[@"curpage"]:1;
            [_collectionView reloadData];
            [self.collectionView.header endRefreshing];
        });
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@" http request error happened !");
        [self.collectionView.header endRefreshing];
        
    }];
}


//添加Tag标签
- (void)tagView:(SKTagView *)tagView addTags:(NSArray *)tags {
    [tags enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        NSDictionary *tagDict = obj;
        SKTag *tag          = [SKTag tagWithText:tagDict[@"name"]];
        tag.textColor       = [UIColor whiteColor];
        tag.cornerRadius    = 2;
        tag.borderWidth     = 0;
        tag.bgColor         = [UIColor colorFromHexString:tagDict[@"bg_color"]];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:11.0];
        tag.font            = font;
        tag.padding         = UIEdgeInsetsMake(3, 3, 2, 2);
        CGSize size = CGSizeMake(80, 20);
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        size = [tag.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
        float Height = size.height;
        float rowHeight = Height + 5;
        NSNumber *tagRowHeight = [[NSNumber alloc] initWithFloat:rowHeight];
        NSNumber *tagCounts =  [[NSNumber alloc] initWithInteger:[tags count]];
        [tagView addTag:tag];
    }];
    
}

//得到合适大小的图片
-(CGSize)getNewImageSize:(CGSize)origionSize maxSize :(CGSize)cellSize{
    
    if(origionSize.width <= 0 || origionSize.height <= 0){
        return CGSizeZero;
    }
    
    CGSize newSize = CGSizeZero;
    float width = cellSize.width;
    float ratio  = width/origionSize.width;
    float height = origionSize.height*ratio;
    newSize = CGSizeMake(width, height);
    
    return newSize;
    
    
    return newSize;
}



//地理定位

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
        _locationManager.distanceFilter = 200.0f;
        [_locationManager startUpdatingLocation];
    }
    

}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = locations[0];
    latitude = currentLocation.coordinate.latitude;
    logitude = currentLocation.coordinate.longitude;
    NSLog(@"logitude:%f",logitude);
    NSLog(@"latitude:%f",latitude);
    
    [_locationManager stopUpdatingLocation];
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Some Error Has Happened!");
    [_locationManager stopUpdatingLocation];
}


//地理位置反编码
-(void) reverseGeocode {
    double lat  = latitude;
    double log  = logitude;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:log];
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks,NSError *error){
        if(error || placemarks == nil){
            NSLog(@"no data :%@",error);
        }
        CLPlacemark *plackmark = [placemarks firstObject];
        NSString *name = plackmark.name;
        NSDictionary *address = plackmark.addressDictionary;
        NSString *subAddress = plackmark.subLocality;
        NSString *counrty = plackmark.country;
        NSLog(@"%@ %@ %@ %@",name,address,subAddress,counrty);
    }];
}

//地理位置 得到经纬度
-(void)geoCoder :(NSString *)address {
    if (address == nil){
        NSLog(@"请输入地址信息");
    }
    
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo geocodeAddressString:address completionHandler:^(NSArray *placemarks,NSError *error){
        if(error || [placemarks count] == 0){
            NSLog(@"您给的地址没有找到");
        }else {
            CLPlacemark *firstMark = [placemarks firstObject];
            NSLog(@"%@ %@ %@ %@",firstMark.country,firstMark.subLocality,firstMark.thoroughfare,firstMark.subThoroughfare);
            
            CLLocationDegrees lat = firstMark.location.coordinate.latitude;
            CLLocationDegrees lng = firstMark.location.coordinate.longitude;
            NSLog(@"Latitude:%f Longitude: %f",lat,lng);
        }
    }];
}


@end
