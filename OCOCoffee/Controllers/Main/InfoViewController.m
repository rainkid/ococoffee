//
//  InfoDetailViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/21.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define  kUserInfoURL               @"/api/user/info"
#define  kInviteUploadImageURL      @"/api/user/invite"

#define  kMaxImageNum               6

#import <Masonry/Masonry.h>
#import <SKTagView/SKTagView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <MWPhotoBrowser/MWCommon.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "UIColor+colorBuild.h"
#import "InfoViewController.h"
#import "InfoCollectionCell.h"
#import "IndexListItem.h"
#import "TagItem.h"
#import "Global.h"
#import "Common.h"
#import "LoginViewController.h"
#import "InviteViewController.h"
#import "TipView.h"


static const CGFloat kPhotoHeight = 146/2;
static const CGFloat slide = 20/2;

@interface InfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate,MBProgressHUDDelegate>

@property(nonatomic, strong) SKTagView *tagView;

@property(nonatomic, strong) UIImageView *headerImageView;
@property(nonatomic, strong) UILabel *nickname;
@property(nonatomic, strong) UILabel *sexAge;
@property(nonatomic, strong) UILabel *jobEduCon;
@property(nonatomic, strong) UILabel *distance;
@property(nonatomic, strong) UILabel *address;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *centerView;
@property(nonatomic, strong) UIView *addressView;
@property(nonatomic, strong) UICollectionView *imgCollectionView;
@property(nonatomic, strong) NSMutableArray *photos;
@property(nonatomic, strong) NSMutableArray *images;
@property(nonatomic, strong) MWPhoto *photo,*thumb;
@property(nonatomic, strong) MWPhotoBrowser *browser;
@property(nonatomic, strong) NSMutableArray *imageList;
@property(nonatomic, strong) MBProgressHUD *HUD;

@end


@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkLogin];
    _imageList = [[NSMutableArray alloc] initWithArray:_images];
    
    [self initSubViews];
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:_HUD];
    _HUD.delegate  = self;
    _HUD.labelText = @"努力加载中";
    [_HUD showWhileExecuting:@selector(loadDataFromServer) onTarget:self withObject:nil animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkLogin
{
    if([Common userIsLogin] == false){
        LoginViewController *loginController = [[LoginViewController alloc] init];
        [self.navigationController presentViewController:loginController animated:YES completion:nil];
    }
}

- (void) initSubViews {
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
    self.headerImageView = ({
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
    [topView addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32/2);
        make.width.height.mas_equalTo(kPhotoHeight);
        make.centerX.equalTo(topView);
    }];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *labelTextCollor = [UIColor colorFromHexString:@"#888888"];
    
    self.nickname = ({
        UILabel *label = [UILabel new];
        label.textColor = labelTextCollor;
        label.font = [UIFont systemFontOfSize:18];
        label;
    });
    [topView addSubview:self.nickname];
    [self.nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.headerImageView.mas_bottom).offset(24/2);
        make.right.mas_equalTo(topView.mas_centerX).offset(-1);
    }];
    
    self.sexAge = ({
        UILabel *label = [UILabel new];
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        label.font = [UIFont systemFontOfSize:12];
        label.layer.borderWidth = 1;
        label;
    });
    [topView addSubview:self.sexAge];
    [self.sexAge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.nickname.mas_centerY);
        make.left.mas_equalTo(topView.mas_centerX).offset(+2);
    }];
    
    
    self.jobEduCon= ({
        UILabel *label = [UILabel new];
        label.font = font;
        label.textColor =labelTextCollor;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [topView addSubview:self.jobEduCon];
    [self.jobEduCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nickname.mas_bottom).offset(24/2);
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
        make.top.mas_equalTo(weakSelf.jobEduCon.mas_bottom).offset(24/2);
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
   // CGFloat aImgHeight = (SCREEN_WIDTH - (4 * slide))/3;
    //CGFloat imgCollectionViewHeight = (aImgHeight*2) + slide;
    
    self.imgCollectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [imgCollectionView setCollectionViewLayout:layout];
        imgCollectionView.dataSource = self;
        imgCollectionView.delegate = self;
        imgCollectionView.backgroundColor = [UIColor clearColor];
        //register cell
        [imgCollectionView registerClass:[InfoCollectionCell class] forCellWithReuseIdentifier:@"imgCollectionCell"];
        imgCollectionView;
    });
    
    
    [self.centerView addSubview:self.imgCollectionView];
    [self.imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tagView.mas_bottom).offset(24/2);
        make.left.mas_equalTo(weakSelf.centerView).offset(slide);
        make.right.mas_equalTo(weakSelf.centerView).offset(-slide);
       // make.height.mas_equalTo(imgCollectionViewHeight);
    }];
    
    CGFloat addressViewHeight = 72/2;
    self.addressView = ({
        UIView *view  = [UIView new];
        view.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
        view.layer.masksToBounds = NO;
        view.layer.shadowColor =  [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(1, 1);
        view.layer.shadowOpacity = 0.1;
        view.layer.shadowRadius = 1;
        view;
    });
    [self.centerView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(addressViewHeight);
        make.right.left.mas_equalTo(weakSelf.imgCollectionView);
       // make.top.mas_equalTo(weakSelf.imgCollectionView.mas_bottom).offset(24/2);
    }];
    
    
    UIImageView *addressImgView = [UIImageView new];
    addressImgView.image = [UIImage imageNamed:@"center_address"];
    [_addressView addSubview:addressImgView];
    [addressImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_addressView).offset(24/2);
        make.centerY.mas_equalTo(_addressView);
    }];

    //
    self.address = ({
        UILabel *label = [UILabel new];
        label.font = font;
        label.textColor = [UIColor colorFromHexString:@"#aeaeae"];
        [_addressView addSubview:label];
        label;
    });
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressImgView.mas_right).offset(24/2);
        make.centerY.mas_equalTo(_addressView);
    }];
    
    //
    self.distance = ({
        UILabel *label = [UILabel new];
        label.font = font;
        label.textColor = labelTextCollor;
        [_addressView addSubview:label];
        label;
    });
    [self.distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_addressView.mas_right).offset(-(24/2));
        make.centerY.mas_equalTo(_addressView);
    }];
    
    [self.centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_addressView.mas_bottom).offset(24/2);
    }];
    
    //邀请
    float inviteHeight = 55;
    
    UIView *inviteView = ({
        UIView *view  =[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - inviteHeight, self.view.frame.size.width,inviteHeight)];
        view.backgroundColor =[UIColor colorFromHexString:@"#f16681"];
        view;
    });
    [self.view addSubview:inviteView];
    UIButton *inviteBtn = ({
       UIButton *button =  [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 200, inviteHeight)];
        button.backgroundColor = [UIColor  clearColor ];
        [button setTitle:@"请TA喝杯咖啡" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(sendInvite) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [inviteView addSubview:inviteBtn];
}

-(void)sendInvite {
    InviteViewController *inviteController = [[InviteViewController alloc] init];
    inviteController.userId =[[NSNumber alloc] initWithLong:self.userId];
    
    UINavigationController *inviteNavController = [[UINavigationController alloc] initWithRootViewController:inviteController];
    [self presentViewController:inviteNavController animated:YES completion:^(void){
        NSLog(@"invite detail view controller");
    }];
}


-(void) loadDataFromServer
{
    NSString *listApiUrl = [NSString stringWithFormat:@"%@%@", API_DOMAIN, kUserInfoURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSNumber *latNumber = [[NSNumber alloc] initWithDouble:self.lati];
//    NSNumber *lngNumber = [[NSNumber alloc] initWithDouble:self.logi];
    NSNumber *userId = [[NSNumber alloc] initWithLong:self.userId];
    NSDictionary *parameters = @{@"lat":_lat, @"lng":_lng, @"id":userId};
    [manager POST:listApiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        dispatch_async(dispatch_get_main_queue(), ^(void){
              [self analyseInfoResponse:responseObject];
        });
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void) analyseInfoResponse:(NSDictionary *)jsonObject {
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        if ([jsonObject[@"success"] integerValue] == 1) {
            NSDictionary *data = jsonObject[@"data"];
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:data[@"headimgurl"]]];
            [self.nickname setText:data[@"nickname"]];
            
            NSString *sexAge = [NSString stringWithFormat:@"%@", data[@"age"]];
            if ([data[@"sex"] floatValue] == 1) {
                self.sexAge.textColor = [UIColor colorFromHexString:@"#5EB6F1"];
                self.sexAge.layer.borderColor = [UIColor colorFromHexString:@"#5EB6F1"].CGColor;
                sexAge = [NSString stringWithFormat:@" %@ %@ ", @"♂", sexAge];
            } else {
                self.sexAge.textColor = [UIColor colorFromHexString:@"#f16681"];
                self.sexAge.layer.borderColor = [UIColor colorFromHexString:@"#f16681"].CGColor;
                sexAge = [NSString stringWithFormat:@" %@ %@ ", @"♀", sexAge];
            }
            [self.sexAge setText:sexAge];
            
            [self.address setText:data[@"address"]];
            [self.distance setText:data[@"distance"]];
            NSString *jobEduCon = [NSString stringWithFormat:@"%@", data[@"constellation"]];
            if ([data[@"education"] length] > 1) {
                jobEduCon = [NSString stringWithFormat:@"%@ | %@", jobEduCon, data[@"education"]];
            }
            if ([data[@"job"] length] > 1) {
                jobEduCon = [NSString stringWithFormat:@"%@ | %@", jobEduCon, data[@"job"]];
            }
            [self.jobEduCon setText: jobEduCon];
            
            NSArray *tags = jsonObject[@"data"][@"tags"];
            [self setupTagView:tags];
            
            NSArray *imgs = jsonObject[@"data"][@"imgs"];
            [self setupUserImgs:imgs];
            
            double height = (SCREEN_WIDTH - (4 * slide))/3 ;
            NSInteger counts = [imgs count];
            if(counts != kMaxImageNum){
                counts +=1;
            }
            double collectionHeight = height * (ceil((double)counts/3));
            [self.imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
                make.height.mas_equalTo(collectionHeight);
                
            }];
    
            [self.addressView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(self.imgCollectionView.mas_bottom).offset(12);
                
            }];
            
            
        } else {
            NSLog(@"response error - %@", jsonObject[@"msg"]);
        }
    } else {
        NSLog(@"response error");
    }
    
}

- (void)setupTagView:(NSArray *)tagList
{
    //Add Tags
    for (NSDictionary *tagItem in tagList) {
        SKTag *tag = [SKTag tagWithText:tagItem[@"name"]];
        tag.textColor = [UIColor whiteColor];
        tag.bgColor = [UIColor colorFromHexString:tagItem[@"bg_color"]];
        tag.cornerRadius = 3;
        tag.fontSize = 13;
        tag.padding = UIEdgeInsetsMake(4, 10, 4, 10);
        [self.tagView addTag:tag];
    }
}

-(void) setupUserImgs:(NSArray *)imgList
{
    _images = [[NSMutableArray alloc] initWithCapacity:imgList.count];
    if([imgList count] > 0){
        for (int i=0; i<imgList.count; i++) {
            NSDictionary *item = imgList[i];
            _photo = [MWPhoto photoWithURL:[NSURL URLWithString:item[@"img"]]];
            [_images addObject:_photo];//用作查看大图
            [_imageList addObject:item];
        }
        
        if([imgList count] < 6){
            NSDictionary *dict = @{@"img":[UIImage imageNamed:@"invite"]};
            [_imageList addObject:dict];
        }
    }else{
            NSDictionary *dict = @{@"img":[UIImage imageNamed:@"invite"]};
            [_imageList addObject:dict];
    }
    [self.imgCollectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_imageList count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger number = [_images count];
    static NSString * CellIdentifier = @"imgCollectionCell";
    InfoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = _imageList[row];
    if(number >0){
        if(number < 6 && row == number){
            [self initlizeInviteCell:cell image:_imageList[row][@"img"]];
        }else{
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]]];
        }
    }else {
        [self initlizeInviteCell:cell image:_imageList[row][@"img"]];
    }
    return cell;
}

//初始化邀请cell
-(void)initlizeInviteCell:(InfoCollectionCell *)cell image:(UIImage *)image {
    cell.imageView.image = image;
    cell.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inviteUploadImg:)];
    [cell.imageView addGestureRecognizer:tapGesture];

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
    _photos = [[NSMutableArray alloc] init];
    [_photos addObjectsFromArray:_images];
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


//图像显示
-(void)showImage:(UITapGestureRecognizer *)tagGestureRecognizer {
    _photos = [[NSMutableArray alloc] initWithCapacity:1];
    MWPhoto *image = [MWPhoto photoWithURL:[NSURL URLWithString:_userInfo.headimgurl]];
    [_photos addObject:image];
    _browser = [self setPhotoBroswer:0];
    [self.navigationController pushViewController:_browser animated:YES];
    _browser = nil;
   
}

//邀请上传图片
-(void)inviteUploadImg:(UITapGestureRecognizer *)tapRecognizer {
        NSString *url = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kInviteUploadImageURL];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *params = @{@"to_uid":_userInfo.userId};
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation,id responseObj){
            if([responseObj isKindOfClass:[NSDictionary class]]){
                CGRect rect = CGRectMake(self.view.center.x-75, self.view.frame.size.height - 100, 150, 30);
                [TipView displayView:self.view withFrame:rect withString:responseObj[@"msg"]];
            }else{
                [Common showErrorDialog:@"请求异常,请稍后再试!"];
            }
        }failure:^(AFHTTPRequestOperation *operation,NSError *error){
           
            NSLog(@"%@",error);
        }];
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
