//
//  IndexViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define BANNERSECTION 0

#import "Global.h"
#import "IndexViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BannerView.h"
#import <Masonry/Masonry.h>
#import "UIColor+colorBuild.h"
#import "IndexCollectionViewCell.h"
#import "InfoViewController.h"
#import "SearchViewController.h"
#import "IndexListItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import <SKTagView/SKTag.h>
#import "IndexCollectionViewFlowLayout.h"
#import <MJRefresh/MJRefresh.h>

static NSString *kCycleBannerIdentifier= @"kbannerIdentifier";
static NSString *kIndexCollectionIdentifier = @"kindexCellIdentifier";
static const CGFloat kBanerHeight = 65;

@interface IndexViewController ()<IndexCollectionViewDelegateFlowLayout,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource, BannerClickedProtocol>

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) BannerView *bannerView;

@property(nonatomic, strong) NSMutableArray *listDataArray;
@property(nonatomic, strong) NSArray *adDataArray;

@property(nonatomic, assign) double userLogitude;
@property(nonatomic, assign) double userLatitude;

@property(nonatomic, assign) CGFloat itemWidth;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger hasNextPage;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一杯咖啡";
   
    [self initTopBar];
    [self initSubViews];
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
        [weakSelf getLocation];
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
    //get list
    NSString *listApiUrl = API_DOMAIN@"api/index/list";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSNumber *latNumber = [[NSNumber alloc] initWithDouble:22.53989800818258];
    NSNumber *lngNumber = [[NSNumber alloc] initWithDouble:114.020138046113];
    NSNumber *pageIndex = [[NSNumber alloc] initWithLong:self.pageIndex];
    NSDictionary *parameters = @{@"lat":latNumber, @"lng":lngNumber, @"page":pageIndex};
    
    [manager GET:listApiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@", responseObject);
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
        
        for (NSDictionary *dict in dicts) {
            IndexListItem *item = [IndexListItem indexListItemWithDictionary:dict];
            [self.listDataArray addObject:item];
        }
        [self.collectionView reloadData];
        
    } else if ([jsonObject[@"data"] respondsToSelector:@selector(count)] && [jsonObject[@"data"] count] == 0) {
        self.pageIndex = 1;
        self.hasNextPage = NO;
        [self.listDataArray removeAllObjects];
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    IndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIndexCollectionIdentifier forIndexPath:indexPath];

    IndexListItem *item = [self.listDataArray objectAtIndex:[indexPath row]];
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:item.headimgurl]];
    cell.nicknameLabel.text = item.nickname;
    cell.ageLabel.text = [NSString stringWithFormat:@"%@", item.age];
    if ([item.sex isEqualToString:@"1"]) {
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
    
    NSLog(@"%@---%d",item.nickname, tagCloum);

    CGFloat cellHeight = KCollectionItemBotHeight + kImageWidth + tagViewHeght ;
    return CGSizeMake(self.itemWidth , cellHeight);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, kBanerHeight);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == BANNERSECTION){
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld-- %ld",indexPath.section,indexPath.row);
    
    InfoViewController *infoViewController = [[InfoViewController alloc] init];
    [self.navigationController pushViewController:infoViewController animated:YES];
    NSLog(@"asdfasdfas");
}

#pragma mark -CLLocationManagerDelegate

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

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = locations[0];
    _userLatitude = currentLocation.coordinate.latitude;
    _userLogitude = currentLocation.coordinate.longitude;
    
    [self loadListFromServer];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self loadListFromServer];
    NSLog(@"locationManager error:%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
