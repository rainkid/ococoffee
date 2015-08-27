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

@interface IndexViewController ()<IndexCollectionViewDelegateFlowLayout,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource, BannerClickedProtocol>

@property(nonatomic, assign) NSInteger newworkStatus;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) Reachability *reachAblity;

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) BannerView *bannerView;

@property(nonatomic, strong) NSMutableArray *listDataArray;
@property(nonatomic, strong) NSArray *adDataArray;

@property(nonatomic, assign) double logitude;
@property(nonatomic, assign) double latitude;

@property(nonatomic, assign) CGFloat itemWidth;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger hasNextPage;

@end

@implementation IndexViewController

-(id)init {
    [self getLocation];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一杯咖啡";
    
    [self initTopBar];
    [self initSubViews];
//     
//    if(_collectionView == nil){
//        indexFlowLayout = [[UICollectionViewFlowLayout alloc] init];
//        indexFlowLayout.minimumInteritemSpacing = 5.0;
//        indexFlowLayout.minimumLineSpacing = 5.0;
//        indexFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//        indexFlowLayout.itemSize  =self.view.bounds.size;
//        
//        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:indexFlowLayout];
//        _collectionView.delegate  = self;
//        _collectionView.dataSource = self;
//        _collectionView.scrollEnabled = YES;
//        _collectionView.scrollsToTop = YES;
//        _collectionView.backgroundColor = [UIColor clearColor];
//        _collectionView.showsVerticalScrollIndicator = NO;
//        
//        [_collectionView registerClass:[BannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCycleBannerIdentifier];
//        [_collectionView registerClass:[IndexCollectionViewCell class] forCellWithReuseIdentifier:kIndexCollectionIdentifier];
//        [self.view addSubview:_collectionView];
//        _dataList = [[NSMutableArray alloc] initWithCapacity:0];
//        _columnHeight = [[NSMutableArray alloc] initWithCapacity:0];
//        _hasNextPage = YES;
//        _curPage = 1;
//    }
//    
//    //网络检测
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newWorkStateChanged:) name:kReachabilityChangedNotification object:nil];
//    _reachAblity = [Reachability reachabilityForInternetConnection];
//    [_reachAblity startNotifier];
//    newworkStatus = [_reachAblity currentReachabilityStatus];
//    
//    //刷新加载数据
//    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
//        if(newworkStatus == 0){
//            [self displayAlertView];
//        }
//        if(_hasNextPage){
//            [self loadNewDataWithPage:_curPage type:@"down"];
//        }else {
//            [_collectionView.header endRefreshing];
//        }
//    }];
//    
//    [_collectionView.header beginRefreshing];
//    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^(void){
//        NSLog(@"Pushing");
//        if(newworkStatus == 0){
//            [self displayAlertView];
//        }
//        if(_hasNextPage){
//            [self loadNewDataWithPage:_curPage type:@"up"];
//        }else{
//            NSLog(@"No More Data");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [_collectionView.footer noticeNoMoreData];
//            });
//        }
//        [_collectionView reloadData];
//        [_collectionView.footer endRefreshing];
//    }];
//    _collectionView.footer.hidden = YES;
//    }
//
//-(void)viewDidAppear:(BOOL)animated
  
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
      // [weakSelf getLocation];
        
        [weakSelf loadListFromServer];
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
    NSNumber *latNumber = [[NSNumber alloc] initWithDouble:22.53992];
    NSNumber *lngNumber = [[NSNumber alloc] initWithDouble:114.0201];
    NSNumber *pageIndex = [[NSNumber alloc] initWithLong:self.pageIndex];
    NSDictionary *parameters = @{@"lat":latNumber, @"lng":lngNumber, @"page":pageIndex};
    [manager GET:listApiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"response:%@",responseObject);
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


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"coutn:%lu",(unsigned long)self.listDataArray.count);
    return [self.listDataArray count]?[self.listDataArray count] :0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    IndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIndexCollectionIdentifier forIndexPath:indexPath];
    
//    NSDictionary *dict = [_dataList objectAtIndex:[indexPath row]];
//    cell.usernameLabel.text     =   dict[@"nickname"];
//    cell.constellation.text     =   dict[@"constellation"];
//    cell.ageLabel.text          =   [NSString stringWithFormat:@"%@",dict[@"age"]];
//    cell.usernameLabel.text     =   dict[@"nickname"];
//    cell.locationLabel.text     =   dict[@"distance"];
//    cell.timeLabel.text         =   dict[@"last_login_time"];
//    if((int)dict[@"sex"] == 1){
//        cell.sexImageView.image = [UIImage imageNamed:@"man.png"];
//    }else{
//        cell.sexImageView.image = [UIImage imageNamed:@"woman.png"];
//    }
//    NSURL *imageURL = [NSURL URLWithString:dict[@"headimgurl"]];
//    [cell.userImageView sd_setImageWithURL:imageURL
//                          placeholderImage:[UIImage imageNamed:@"img1"]
//                                 completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,NSURL *imageURL){
//                                     CGSize newSize = [self getNewImageSize:cell.userImageView.image.size maxSize:cell.contentView.frame.size];
//                                     cell.userImageView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
//    }];
//    NSArray *tags = dict[@"tags"];
//    [cell.tagView removeAllTags];
//    [self tagView:cell.tagView addTags:tags];
    
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
    
    //NSLog(@"%@---%d",item.nickname, tagCloum);

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
    infoViewController.latitude = self.latitude;
    infoViewController.logitude = self.logitude;
    
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


//网络加载数据
//-(void)loadNewDataWithPage:(int)page  type:(NSString *)type {
//    
//    [_locationManager startUpdatingLocation];
//    double lat = _latitude;
//    double lng = _logitude;
//    NSLog(@"%f,%f",lat,lng);
//    lat =22.53992;
//    lng =114.0201;
//  
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
//    CLGeocoder *gcoder = [[CLGeocoder alloc] init];
//    [gcoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks,NSError *error){
//        if(!error && [placemarks count]>0){
//            CLPlacemark *placeMark = [placemarks firstObject];
//           // NSLog(@" distinct:%@ \n address:%@ \n city:%@ \n ",placeMark.name,placeMark.addressDictionary,placeMark.country);
//            NSDictionary *dict = placeMark.addressDictionary;
//            NSString *detailAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
//                                       dict[@"State"],dict[@"City"],dict[@"SubLocality"],dict[@"Name"],dict[@"Street"]
//                                       ];
//           // NSLog(@"%@",detailAddress);
//            
//        }
//    }];
//
//    NSNumber *latitu = [NSNumber numberWithDouble:lat];
//    NSNumber *logitu = [NSNumber numberWithDouble:lng];
//    NSDictionary *dict = @{@"lat":latitu,@"lng":logitu,@"page":[NSNumber numberWithInt:page]};
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:base_url parameters:dict success:^(AFHTTPRequestOperation  *operation,id responseObject){
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSDictionary *dict = responseObject;
//            NSArray *list = dict[@"data"][@"list"];
//            
//            //下拉刷新时
//            if([type  isEqual: @"down"]){
//                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [list count])];
//                [_dataList insertObjects:list atIndexes:indexes];
//            }else{
//                [_dataList addObjectsFromArray:list];
//            }
//            _hasNextPage    = dict[@"hasnext"]?dict[@"hasnext"]:FALSE;
//            _curPage        =dict[@"curpage"]? (int)dict[@"curpage"]:1;
//            [_collectionView reloadData];
//            [self.collectionView.header endRefreshing];
//        });
//        
//    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
//        NSLog(@" http request error happened !");
//        [self.collectionView.header endRefreshing];
//        
//    }];
//}


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



//地理定位
#pragma mark -CLLocationManagerDelegate

-(void)getLocation {
    
    if(_locationManager == nil){
        _locationManager = [[CLLocationManager alloc] init];
        
    }
    
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
    _latitude = currentLocation.coordinate.latitude;
    _logitude = currentLocation.coordinate.longitude;
    
    NSLog(@"%f",_latitude);
    
    [self loadListFromServer];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //[self loadListFromServer];
    NSLog(@"locationManager error:%@", error);
}


//地理位置反编码
-(void) reverseGeocode {
    double lat  = _latitude;
    double log  = _logitude;
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
