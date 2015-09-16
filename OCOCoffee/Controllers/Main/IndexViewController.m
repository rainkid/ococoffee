//
//  IndexViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define BANNERSECTION 0


#import <CoreLocation/CoreLocation.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import <SKTagView/SKTag.h>
#import <MJRefresh/MJRefresh.h>
#import <BaiduMapAPI/BMapKit.h>

#import "Global.h"
#import "BannerView.h"
#import "Reachability.h"
#import "IndexListItem.h"
#import "UIColor+colorBuild.h"
#import "InfoViewController.h"
#import "IndexViewController.h"
#import "SearchViewController.h"
#import "IndexCollectionViewCell.h"
#import "IndexCollectionViewFlowLayout.h"



static NSString *kCycleBannerIdentifier= @"kbannerIdentifier";
static NSString *kIndexCollectionIdentifier = @"kindexCellIdentifier";

static const CGFloat kBanerHeight = 65;

@interface IndexViewController ()<IndexCollectionViewDelegateFlowLayout,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource, BannerClickedProtocol,BMKLocationServiceDelegate>

@property(nonatomic, assign) NSInteger newworkStatus;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) Reachability *reachAblity;

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) BannerView *bannerView;

@property(nonatomic, strong) NSMutableArray *listDataArray;
@property(nonatomic, strong) NSArray *adDataArray;

@property(nonatomic, strong) NSString *longitude;
@property(nonatomic, strong) NSString *latitude;

@property(nonatomic, assign) CGFloat itemWidth;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger hasNextPage;
@property(nonatomic,strong)  BMKLocationService *locationService;

@end

@implementation IndexViewController


-(void)viewWillAppear:(BOOL)animated {
    
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [BMKLocationService setLocationDistanceFilter:100.0f];
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    [_locationService startUserLocationService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一杯咖啡";
    
    [self initTopBar];
    [self initSubViews];
    //网络检测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newWorkStateChanged:) name:kReachabilityChangedNotification object:nil];
    _reachAblity = [Reachability reachabilityForInternetConnection];
    [_reachAblity startNotifier];
    _newworkStatus = [_reachAblity currentReachabilityStatus];


}

- (void) initTopBar
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"筛选"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(search)
                                      ];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"设置"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(settings)
                                    ];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) initSubViews
{
    __weak __typeof(self) weakSelf = self;

    self.itemWidth = SCREEN_WIDTH/2 -10;
    self.listDataArray = [NSMutableArray array];
    
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#f5f5f5"]];
    
    self.collectionView = ({
        UICollectionViewFlowLayout *indexLayout = [[UICollectionViewFlowLayout alloc] init];
        indexLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        indexLayout.itemSize  =self.view.bounds.size;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:indexLayout];
        collectionView.delegate  = self;
        collectionView.dataSource = self;
        collectionView.scrollEnabled = YES;
        collectionView.scrollsToTop = YES;
        collectionView.frame = weakSelf.view.frame;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsVerticalScrollIndicator = NO;
        
        [collectionView registerClass:[BannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCycleBannerIdentifier];
        [collectionView registerClass:[IndexCollectionViewCell class] forCellWithReuseIdentifier:kIndexCollectionIdentifier];
        collectionView;
    });
    [self.view addSubview:self.collectionView];
    
    //load data
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        [weakSelf loadAdFromServer];
        if(_latitude != nil){
            [weakSelf loadListFromServer];
        }
    }];

    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^(void){
        [self loadListFromServer];
    }];
}

-(void) loadAdFromServer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //get ad
    NSString *indexAdUrl = API_DOMAIN@"/api/index/ad";
    [manager GET:indexAdUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self analyseAdJsonObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error with %@ : %@", indexAdUrl, error);
    }];
}

-(void)search {
    
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    
    [self presentViewController:searchNavigationController animated:YES completion:^(void){
        NSLog(@"sessued");
    }];
}

-(void)settings {
    
}

- (void) loadListFromServer
{
    NSString *listApiUrl = API_DOMAIN@"api/index/list";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSNumber *pageIndex = [[NSNumber alloc] initWithLong:self.pageIndex];
    NSDictionary *parameters = @{@"lat":_latitude, @"lng":_longitude, @"page":pageIndex};
    [manager GET:listApiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self analyseListJsonObject:responseObject];
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)analyseListJsonObject:(NSDictionary *)jsonObject
{
    if ([jsonObject[@"data"] isKindOfClass:[NSDictionary class]]) {
        NSArray *dicts;
        if (jsonObject[@"data"][@"list"]) {
            dicts = jsonObject[@"data"][@"list"];
        }
        if (jsonObject[@"data"][@"curpage"]) {
            self.pageIndex = [jsonObject[@"data"][@"curpage"] integerValue];
        }
        if (jsonObject[@"data"][@"hasnext"]) {
            self.hasNextPage = [jsonObject[@"data"][@"hasnext"] boolValue];
        }
        
        if([dicts count] >0){
            for (NSDictionary *dict in dicts) {
                IndexListItem *item = [IndexListItem indexListItemWithDictionary:dict];
                [self.listDataArray addObject:item];
            }
        }
        [self.collectionView reloadData];
        
    } else if ([jsonObject[@"data"] respondsToSelector:@selector(count)] && [jsonObject[@"data"] count] == 0) {
        self.pageIndex = 1;
        self.hasNextPage = NO;
        [self.listDataArray removeAllObjects];
        [self.collectionView reloadData];
    }
}

- (void)analyseAdJsonObject:(NSDictionary *)jsonObject
{

    if ([jsonObject[@"data"] isKindOfClass:[NSArray class]]) {
        NSArray *adArray = [NSMutableArray array];
        if (jsonObject[@"data"]) {
            adArray = jsonObject[@"data"];
        }
        self.adDataArray = adArray;
        [self reloadBanerData];
    }
}

-(void) reloadBanerData
{
    [self.bannerView forceRefresh:self.adDataArray];
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

#pragma mark - BannerClickedProtocol
- (void)clickedBanner:(NSDictionary *)dict
{
    NSLog(@"%@", dict);
}


#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(IndexCollectionViewFlowLayout *)layout numberOfColumnsInSection:(NSInteger)section{
    return 2;
}


#pragma collection datasource methods


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.listDataArray count]?[self.listDataArray count] :0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    IndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIndexCollectionIdentifier forIndexPath:indexPath];

    IndexListItem *item = [self.listDataArray objectAtIndex:[indexPath row]];
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:item.headimgurl]];
    cell.nicknameLabel.text = item.nickname;
    cell.ageLabel.text = [NSString stringWithFormat:@"%@", item.age];
    cell.locationLabel.text = item.distance;
    cell.timeLabel.text = item.last_login_time;
    cell.constellation.text= item.constellation;
    if ([item.sex floatValue] == 1) {
        cell.sexLabel.text = @"♂";
    } else {
        cell.sexLabel.text = @"♀";
    }

    [cell.tagView removeAllTags];
    for (TagItem *tagItem in item.TagItems) {
        SKTag *tag          = [SKTag tagWithText:tagItem.name];
        tag.textColor       = [UIColor whiteColor];
        tag.cornerRadius    = 2;
        tag.borderWidth     = 0;
        tag.bgColor         = [UIColor colorFromHexString:tagItem.bg_color];
        tag.font            = [UIFont fontWithName:@"Helvetica" size:11.0];
        tag.padding         = UIEdgeInsetsMake(2, tagItemRightPading, 2, tagItemLeftPading);
        [cell.tagView addTag:tag];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IndexListItem *item = [self.listDataArray objectAtIndex:[indexPath row]];
    int tagCloum = 1;
    CGFloat kImageWidth = self.itemWidth;
    CGFloat cellLessWith = self.itemWidth - tagViewLeftPading - tagViewRightPading;
    cellLessWith = cellLessWith - (tagViewInserts*(item.TagItems.count - 1));
    CGFloat tagItemHeight = 11 + tagViewLineSpace + 4;

    int i = 0;
    for (TagItem *tagItem in item.TagItems) {
       // string = [NSString stringWithFormat:@"%@,%@", string, tagItem.name];
        NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
        CGFloat tagTextWidth = [tagItem.name boundingRectWithSize:CGSizeMake(MAXFLOAT, tagItemHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.width;
        
        CGFloat tagItemWidth = tagTextWidth + (tagItemLeftPading+tagItemRightPading);
              
        if(cellLessWith > tagItemWidth){
            cellLessWith = cellLessWith - tagItemWidth;
        } else {
            tagCloum++;
            cellLessWith = self.itemWidth;
        }
        i++;
    }
    
    CGFloat tagViewHeght = (tagCloum * tagItemHeight);
    CGFloat cellHeight = KCollectionItemBotHeight + kImageWidth + tagViewHeght ;
    return CGSizeMake(self.itemWidth , cellHeight);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, kBanerHeight);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if(_bannerView == nil){
            _bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCycleBannerIdentifier forIndexPath:indexPath];
            _bannerView.delegate = self;
         }
         return _bannerView;
    }
    return [UICollectionReusableView new];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    InfoViewController *infoViewController = [[InfoViewController alloc] init];
    IndexListItem *item = [self.listDataArray objectAtIndex:[indexPath row]];
    infoViewController.userId = [item.userId floatValue];
    infoViewController.userInfo = item;
    infoViewController.lat = self.latitude;
    infoViewController.lng = self.longitude;
    
    [self.navigationController pushViewController:infoViewController animated:YES];
}

-(NSArray *)layoutAttributesForElementsInRect {
    return [NSArray new];
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
        _newworkStatus = 2;
    }else if ([link currentReachabilityStatus] != NotReachable){
        _newworkStatus = 1;
        NSLog(@"可以使用手机网络上网");
    }else {
        NSLog(@"没有可用网络");
    }
}

//添加Tag标签
- (void)tagView:(SKTagView *)tagView addTags:(NSArray *)tags {
    
    if([tags count]>0){
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


//百度地图定位
-(void)willStartLocatingUser {
    NSLog(@"将要开始定位");
    BMKUserLocation *coor = _locationService.userLocation;
    NSLog(@"当前经度：%f",coor.location.coordinate.latitude);
}

-(void)didStopLocatingUser {
    NSLog(@"停止定位！");
}
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"user—latitude:%f user-longitude:%f",userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    double lat = userLocation.location.coordinate.latitude;
    double lng = userLocation.location.coordinate.longitude;
    _longitude = [NSString stringWithFormat:@"%f",lng];
    _latitude  = [NSString stringWithFormat:@"%f",lat];
    [self loadListFromServer];
}

-(void)didFailToLocateUserWithError:(NSError *)error {
    //[_locationService stopUserLocationService];
    NSLog(@"百度定位错误提示:%@",error);
}

//地理定位
#pragma mark -CLLocationManagerDelegate
//
//-(void)getLocation {
//    
//    if(_locationManager == nil){
//        _locationManager = [[CLLocationManager alloc] init];
//        
//    }
//    
//    if(![CLLocationManager locationServicesEnabled]){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
//                                                            message:@"还没有开启定位服务"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles: nil
//                                  ];
//        [alertView show];
//    }
//    
//    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
//        [_locationManager requestWhenInUseAuthorization];
//    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
//                                                        message:@"请在系统设置中开启定位服务"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles: nil
//                              ];
//        [alert show];
//        
//    }else {
//        _locationManager.delegate = self;
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        _locationManager.distanceFilter = 200.0f;
//        [_locationManager startUpdatingLocation];
//    }
//}
//



@end
