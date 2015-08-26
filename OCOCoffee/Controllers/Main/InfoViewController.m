//
//  InfoDetailViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/21.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <SKTagView/SKTagView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Global.h"
#import "UIColor+colorBuild.h"
#import "InfoViewController.h"
#import "InfoCollectionCell.h"
#import <AFNetworking/AFNetworking.h>
#import "IndexListItem.h"



static const CGFloat kPhotoHeight = 146/2;
static const CGFloat slide = 20/2;

@interface InfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>



@property(nonatomic, strong) SKTagView *tagView;

@property(nonatomic, strong) UIImageView *headerImageView;
@property(nonatomic, strong) UILabel *nickname;
@property(nonatomic, strong) UILabel *sexAge;
@property(nonatomic, strong) UILabel *jobEduCon;
@property(nonatomic, strong) UILabel *distance;
@property(nonatomic, strong) UILabel *address;

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *centerView;
@property(nonatomic, strong) UICollectionView *imgCollectionView;

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
    
    [self initSubViews];
    [self loadDataFromServer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [imgCollectionView registerClass:[InfoCollectionCell class] forCellWithReuseIdentifier:@"imgCollectionCell"];
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
    self.address = ({
        UILabel *label = [UILabel new];
        label.font = font;
        label.textColor = [UIColor colorFromHexString:@"#aeaeae"];
        [addressView addSubview:label];
        label;
    });
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressImgView.mas_right).offset(24/2);
        make.centerY.mas_equalTo(addressView);
    }];
    
    //
    self.distance = ({
        UILabel *label = [UILabel new];
        label.font = font;
        label.textColor = labelTextCollor;
        [addressView addSubview:label];
        label;
    });
    [self.distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(addressView.mas_right).offset(-(24/2));
        make.centerY.mas_equalTo(addressView);
    }];
    
    [self.centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(addressView.mas_bottom).offset(24/2);
    }];
}

-(void) loadDataFromServer
{
    NSString *listApiUrl = API_DOMAIN@"api/user/info";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSNumber *latNumber = [[NSNumber alloc] initWithDouble:self.latitude];
    NSNumber *lngNumber = [[NSNumber alloc] initWithDouble:self.logitude];
    NSNumber *userId = [[NSNumber alloc] initWithLong:self.userId];
    
    NSDictionary *parameters = @{@"lat":latNumber, @"lng":lngNumber, @"id":userId};
    
    [manager POST:listApiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@", responseObject);
        [self analyseInfoResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) analyseInfoResponse:(NSDictionary *)jsonObject
{
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
        tag.textColor = [UIColor blackColor];
        tag.bgColor = [UIColor colorFromHexString:tagItem[@"bg_color"]];
        tag.cornerRadius = 3;
        tag.fontSize = 13;
        tag.padding = UIEdgeInsetsMake(4, 10, 4, 10);
        [self.tagView addTag:tag];
    }
}

-(void) setupUserImgs:(NSArray *)imgList
{
    for (int i=0; i<imgList.count; i++) {
        NSDictionary *item = imgList[i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        InfoCollectionCell * cell = (InfoCollectionCell *)[self.imgCollectionView cellForItemAtIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item[@"img"]]];
        i++;
    }
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"imgCollectionCell";
    InfoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
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

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
