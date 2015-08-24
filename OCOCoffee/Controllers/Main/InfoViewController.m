//
//  InfoDetailViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/21.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "Global.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import "InfoViewController.h"
#import <SKTagView/SKTagView.h>


static const CGFloat kPhotoHeight = 146/2;
static const CGFloat slide = 20/2;
static const CGFloat buttonHeight = 106/2;

@interface InfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) NSDictionary *activityData;

@property(nonatomic, strong) SKTagView *tagView;
@property(nonatomic, assign) bool isCenterHidden;

@property(nonatomic, strong) UIButton *upButton;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *centerView;
@property(nonatomic, assign) CGFloat centerViewHeight;
@property(nonatomic, strong) UICollectionView *imgCollectionView;

@end



@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _activityData = [[NSDictionary alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        _isCenterHidden = false;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self initData];
    [self initSubViews];
    
    [self setupTagView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData {
    
}

- (void) initSubViews {
    __weak typeof(self) weakSelf = self;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
    self.title = @"个人详情";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = YES;
    [scrollView setContentOffset:CGPointZero animated:YES];
    scrollView.contentSize = CGSizeMake(weakSelf.view.frame.size.width, weakSelf.view.frame.size.height+PHONE_NAVIGATIONBAR_HEIGHT+PHONE_STATUSBAR_HEIGHT + buttonHeight);
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
    UIImageView *headerImageView = [UIImageView new];
    headerImageView.image = [UIImage imageNamed:@"sample_logo"];
    headerImageView.layer.cornerRadius = (kPhotoHeight) /2;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.userInteractionEnabled = YES;
    [topView addSubview:headerImageView];
    
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32/2);
        make.width.height.mas_equalTo(kPhotoHeight);
        make.centerX.equalTo(topView);
    }];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *labelTextCollor = [UIColor colorFromHexString:@"#888888"];
    
    
    UILabel *nicknameLabel = [UILabel new];
    nicknameLabel.text = @"董事长";
    nicknameLabel.textColor = labelTextCollor;
    nicknameLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImageView.mas_bottom).offset(24/2);
        make.right.mas_equalTo(topView.mas_centerX).offset(-1);
    }];
    
    UILabel *sexAgeLabel = [UILabel new];
    sexAgeLabel.layer.cornerRadius = 3;
    sexAgeLabel.layer.masksToBounds = YES;
    sexAgeLabel.textColor = [UIColor colorFromHexString:@"#f16681"];
    sexAgeLabel.layer.borderColor = [UIColor colorFromHexString:@"#f16681"].CGColor;
    sexAgeLabel.layer.borderWidth = 1;
    sexAgeLabel.text = [NSString stringWithFormat:@" %@%@ ", @"♀", @"18"];
    sexAgeLabel.font = font;
    [topView addSubview:sexAgeLabel];
    [sexAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImageView.mas_bottom).offset(24/2);
        make.centerY.mas_equalTo(nicknameLabel.mas_centerY);
        make.left.mas_equalTo(topView.mas_centerX).offset(+1);
    }];
    
    
    UILabel *jobLabel = [UILabel new];
    jobLabel.text = @"巨蟹座 | 本科 | 商业/服务业/个体经营";
    jobLabel.font = font;
    jobLabel.textColor =labelTextCollor;
    jobLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:jobLabel];
    [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nicknameLabel.mas_bottom).offset(24/2);
        make.left.right.mas_equalTo(topView);
    }];
    
    SKTagView *tagView = [SKTagView new];
    tagView.padding    = UIEdgeInsetsMake(0, 0, 0, 0);
    tagView.insets    = 5;
    tagView.lineSpace = 5;
    self.tagView = tagView;
    [topView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jobLabel.mas_bottom).offset(24/2);
        make.centerX.mas_equalTo(topView);
    }];
    
    UIView *centerView = [UIView new];
    centerView.backgroundColor = [UIColor whiteColor];
    self.centerView = centerView;
    [scrollView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.width.mas_equalTo(scrollView);
    }];
    
    [topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tagView.mas_bottom);
    }];
    
    //img collection view
    CGFloat aImgHeight = (SCREEN_WIDTH - (4 * slide))/3;
    CGFloat imgCollectionViewHeight = (aImgHeight*2) + slide;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [imgCollectionView setCollectionViewLayout:layout];
    imgCollectionView.dataSource = self;
    imgCollectionView.delegate = self;
    imgCollectionView.backgroundColor = [UIColor clearColor];
    //register cell
    [imgCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imgCollectionCell"];
    self.imgCollectionView = imgCollectionView;
    [centerView addSubview:imgCollectionView];
    [imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tagView.mas_bottom).offset(24/2);
        make.left.mas_equalTo(centerView).offset(slide);
        make.right.mas_equalTo(centerView).offset(-slide);
        make.height.mas_equalTo(imgCollectionViewHeight);
    }];
    
    CGFloat addressViewHeight = 72/2;
    UIView *addressView = [UIView new];
    addressView.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    addressView.layer.masksToBounds = NO;
    addressView.layer.shadowColor =  [UIColor blackColor].CGColor;
    addressView.layer.shadowOffset = CGSizeMake(1, 1);
    addressView.layer.shadowOpacity = 0.1;
    addressView.layer.shadowRadius = 1;
    
    [centerView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(addressViewHeight);
        make.right.left.mas_equalTo(imgCollectionView);
        make.top.mas_equalTo(imgCollectionView.mas_bottom).offset(24/2);
    }];
    self.centerViewHeight = imgCollectionViewHeight;
    
    
    UIImageView *addressImgView = [UIImageView new];
    addressImgView.image = [UIImage imageNamed:@"center_address"];
    [addressView addSubview:addressImgView];
    [addressImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressView).offset(24/2);
        make.centerY.mas_equalTo(addressView);
    }];
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = @"阳光高尔夫大厦";
    addressLabel.font = font;
    addressLabel.textColor = [UIColor colorFromHexString:@"#aeaeae"];
    [addressView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressImgView.mas_right).offset(24/2);
        make.centerY.mas_equalTo(addressView);
    }];
    
    UILabel *lonsLabel = [UILabel new];
    lonsLabel.text = @"0.54km  刚刚";
    lonsLabel.font = font;
    lonsLabel.textColor = labelTextCollor;
    [addressView addSubview:lonsLabel];
    [lonsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(addressView.mas_right).offset(-(24/2));
        make.centerY.mas_equalTo(addressView);
    }];
    
    [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(addressView.mas_bottom).offset(24/2);
    }];
}

- (void)setupTagView
{
    //Add Tags
    [@[@"电烧友", @"电影控", @"吃货", @"旅游达人", @"好人一个"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [self addTagWithObj:obj];
     }];
}

- (void) addTagWithObj:(id)obj
{
    SKTag *tag = [SKTag tagWithText:obj];
    tag.textColor = [UIColor blackColor];
    tag.bgColor = [UIColor colorFromHexString:@"#ffa99c"];
    tag.cornerRadius = 3;
    tag.fontSize = 13;
    tag.padding = UIEdgeInsetsMake(4, 10, 4, 10);
    
    [self.tagView addTag:tag];
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
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
