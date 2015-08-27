//
//  InfoDetailViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/21.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define  kUserInfoURL  @"http://ococoffee.com/api/user/info"

#import <Masonry/Masonry.h>
#import <SKTagView/SKTagView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <MWPhotoBrowser/MWCommon.h>
#import <AFNetworking/AFNetworking.h>

#import "PhotoBroswerViewController.h"
#import "UIColor+colorBuild.h"
#import "InfoViewController.h"
#import "IndexListItem.h"
#import "TagItem.h"
#import "Global.h"




static const CGFloat kPhotoHeight = 146/2;
static const CGFloat slide = 20/2;
//static const CGFloat buttonHeight = 106/2;

@interface InfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property(nonatomic, strong) NSMutableData *userData;
@property(nonatomic, strong) SKTagView *tagView;
@property(nonatomic, strong) UIButton *upButton;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *centerView;
@property(nonatomic, assign) CGFloat centerViewHeight;
@property(nonatomic, strong) UICollectionView *imgCollectionView;
@property(nonatomic,strong)  NSMutableArray *photos;
@property(nonatomic,strong) MWPhoto *photo,*thumb;
@property(nonatomic,strong) MWPhotoBrowser *browser;

@end




@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //_userData = [[NSMutableDictionary alloc] initWithCapacity:1];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initData];
    [self.imgCollectionView reloadData];
    
    [self initSubViews];
    
    [self setupTagView];
    
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData {

    NSString *urlString = [NSString stringWithFormat:@"%@?id=%@",kUserInfoURL,_userInfo.userId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection){
        _userData = [[NSMutableData alloc] init];
    }else{
        NSLog(@"error has happened when connectioning!");
    }
//    _userData = [[NSMutableDictionary alloc] initWithCapacity:1];
//    AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] init];
//    [manger GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
//        NSDictionary *dict = responseObject[@"data"];
//        if([dict isKindOfClass:[NSDictionary class]]){
//            [_userData addEntriesFromDictionary:dict];
//            //NSLog(@"%@",_userData);
//        }else{
//            NSLog(@"用户信息不存在");
//        }
//        
//       } failure:^(AFHTTPRequestOperation *operation,NSError *error){
//            NSLog(@"%@",error);
//    }];
//
//    NSLog(@"%@",_userData);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
 
    [_userData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [_userData setLength:0];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"finishned");
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@",error);
    
}
- (void) initSubViews {
    
   // [self initData];
    
   NSLog(@"_userData:%@",_userData);
    
    __weak typeof(self) weakSelf = self;
    self.title = @"个人详情";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#f5f5f5"]];
    
    UIScrollView *scrollView = ({
        UIScrollView *view = [UIScrollView new];
        view.scrollEnabled = YES;
        view.showsVerticalScrollIndicator = NO;
        [view setContentOffset:CGPointZero animated:YES];
        view.contentSize = CGSizeMake(weakSelf.view.frame.size.width, weakSelf.view.frame.size.height-PHONE_NAVIGATIONBAR_HEIGHT-PHONE_STATUSBAR_HEIGHT);
        view;
    });
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(weakSelf.view);
    }];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    self.topView = topView;
    [scrollView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.mas_equalTo(scrollView);
    }];
    
    //用户图像
    UIImageView *headerImageView = ({
        UIImageView *imageView = [UIImageView new];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.headimgurl] placeholderImage:[UIImage imageNamed:@"sample_logo"] options:SDWebImageContinueInBackground  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(error != nil){
                [imageView setImage:[UIImage imageNamed:@"sample_logo"]];
            }
            
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
        [imageView addGestureRecognizer:tap];
        
        
        imageView.layer.cornerRadius = (kPhotoHeight) /2;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView;
    });
    [topView addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32/2);
        make.width.height.mas_equalTo(kPhotoHeight);
        make.centerX.equalTo(topView);
    }];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *labelTextCollor = [UIColor colorFromHexString:@"#888888"];
    
    
    UILabel *nicknameLabel = ({
        UILabel *label = [UILabel new];
        label.text = _userInfo.nickname;
        label.textColor = labelTextCollor;
        label.font = [UIFont systemFontOfSize:18];
        label;
    });
    [topView addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImageView.mas_bottom).offset(24/2);
        make.right.mas_equalTo(topView.mas_centerX).offset(-1);
    }];
    
    UILabel *sexAgeLabel = ({
        UILabel *label = [UILabel new];
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        label.textColor = [UIColor colorFromHexString:@"#f16681"];
        label.layer.borderColor = [UIColor colorFromHexString:@"#f16681"].CGColor;
        label.layer.borderWidth = 1;
        NSString *sex = [_userInfo.sex isEqualToString:@"1"] ?@"♂":@"♀";
        label.text = [NSString stringWithFormat:@" %@%@ ", sex, _userInfo.age];
        label.font = font;
        label;
    });
    [topView addSubview:sexAgeLabel]; 
    [sexAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImageView.mas_bottom).offset(24/2);
        make.centerY.mas_equalTo(nicknameLabel.mas_centerY);
        make.left.mas_equalTo(topView.mas_centerX).offset(+1);
    }];
    
    
    UILabel *jobLabel = ({
        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"%@ | %@ | %@",_userInfo.constellation,@"本科",@"个体经营者"];
        label.font = font;
        label.textColor =labelTextCollor;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [topView addSubview:jobLabel];
    [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nicknameLabel.mas_bottom).offset(24/2);
        make.left.right.mas_equalTo(topView);
    }];
    
    self.tagView = ({
        SKTagView * tagView = [SKTagView new];
        tagView.padding    = UIEdgeInsetsMake(0, 0, 0, 0);
        tagView.insets    = 5;
        tagView.lineSpace = 5;
        tagView;
    });
    [topView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jobLabel.mas_bottom).offset(24/2);
        make.centerX.mas_equalTo(topView);
    }];
    
    self.centerView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [scrollView addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.width.mas_equalTo(scrollView);
    }];
    
    [topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.tagView.mas_bottom);
    }];
    
    //img collection view
    CGFloat aImgHeight = (SCREEN_WIDTH - (4 * slide))/3;
    CGFloat imgCollectionViewHeight = (aImgHeight*2) + slide;
    
    self.imgCollectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [imgCollectionView setCollectionViewLayout:layout];
        imgCollectionView.dataSource = self;
        imgCollectionView.delegate = self;
        imgCollectionView.backgroundColor = [UIColor clearColor];
        //register cell
        [imgCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imgCollectionCell"];
        imgCollectionView;
    });
    
    
    [self.centerView addSubview:self.imgCollectionView];
    [self.imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tagView.mas_bottom).offset(24/2);
        make.left.mas_equalTo(weakSelf.centerView).offset(slide);
        make.right.mas_equalTo(weakSelf.centerView).offset(-slide);
        make.height.mas_equalTo(imgCollectionViewHeight);
    }];
    
    CGFloat addressViewHeight = 72/2;
    UIView *addressView = ({
        UIView *view  = [UIView new];
        view.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
        view.layer.masksToBounds = NO;
        view.layer.shadowColor =  [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(1, 1);
        view.layer.shadowOpacity = 0.1;
        view.layer.shadowRadius = 1;
        view;
    });
    [self.centerView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(addressViewHeight);
        make.right.left.mas_equalTo(weakSelf.imgCollectionView);
        make.top.mas_equalTo(weakSelf.imgCollectionView.mas_bottom).offset(24/2);
    }];
    
    
    UIImageView *addressImgView = [UIImageView new];
    addressImgView.image = [UIImage imageNamed:@"center_address"];
    [addressView addSubview:addressImgView];
    [addressImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressView).offset(24/2);
        make.centerY.mas_equalTo(addressView);
    }];

    //
    UILabel *addressLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"阳光高尔夫大厦";
        label.font = font;
        label.textColor = [UIColor colorFromHexString:@"#aeaeae"];
        [addressView addSubview:label];
        label;
    });
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressImgView.mas_right).offset(24/2);
        make.centerY.mas_equalTo(addressView);
    }];
    
    //
    UILabel *lonsLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"0.54km  刚刚";
        label.font = font;
        label.textColor = labelTextCollor;
        [addressView addSubview:label];
        label;
    });
    [lonsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(addressView.mas_right).offset(-(24/2));
        make.centerY.mas_equalTo(addressView);
    }];
    
    [self.centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(addressView.mas_bottom).offset(24/2);
    }];
}

- (void)setupTagView
{
    [self.tagView removeAllTags];
    
    for (TagItem *item in _userInfo.TagItems) {
        SKTag *tag = [SKTag tagWithText:item.name];
        tag.textColor = [UIColor whiteColor];
        tag.bgColor = [UIColor colorFromHexString:item.bg_color];
        tag.cornerRadius = 3;
        tag.fontSize = 13;
        tag.padding = UIEdgeInsetsMake(4, 10, 4, 10);
        [self.tagView addTag:tag];
    }
}


#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"imgCollectionCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.layer.shadowColor =  [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(1, 1);
    cell.layer.shadowOpacity = 0.1;
    cell.layer.shadowRadius = 3;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgView.image = [UIImage imageNamed:@"sample_p"];
    imgView.layer.masksToBounds = YES;
    imgView.layer.cornerRadius = 3;
    [cell addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(cell);
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - (4 * slide))/3;
    return CGSizeMake(width, width);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    _photos = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i< 5; i++) {
        
        _photo = [MWPhoto photoWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img%d.png",i+1]]];
        _photo.caption = @"这是一个测试图片";
        [_photos addObject:_photo];
    }
    _browser = [self setPhotoBroswer:indexPath.row];
    [self.navigationController pushViewController:_browser animated:YES];
}


#pragma MWPhotoBrowser delegate methods

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [_photos count];
}

-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if ( index < _photos.count){
        return [ _photos objectAtIndex:index];
    }
    
    return nil;
}


-(void)showImage:(UITapGestureRecognizer *)tagGestureRecognizer {
    _photos = [[NSMutableArray alloc] initWithCapacity:2];
    MWPhoto *image = [MWPhoto photoWithURL:[NSURL URLWithString:_userInfo.headimgurl]];
    [_photos addObject:image];
    _browser = [self setPhotoBroswer:0];
    [self.navigationController pushViewController:_browser animated:YES];
    _browser = nil;
}

-(MWPhotoBrowser *)setPhotoBroswer :(NSInteger)index {
        _browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _browser.displayActionButton     = NO;
        _browser.displayNavArrows        = YES;
        _browser.displaySelectionButtons = NO;
        _browser.zoomPhotosToFill        = YES;
        _browser.enableGrid              = YES;
        _browser.enableSwipeToDismiss    = YES;
        _browser.alwaysShowControls      = NO;
        _browser.startOnGrid             = NO;
        _browser.delayToHideElements     = YES;
        [_browser setCurrentPhotoIndex:index];
        [_browser setStartOnGrid:NO];
        return _browser;
}

@end
