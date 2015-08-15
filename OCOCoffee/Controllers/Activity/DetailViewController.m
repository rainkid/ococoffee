//
//  DetailViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/13.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//
#import "Golbal.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import "DetailViewController.h"
#import <SKTagView/SKTagView.h>


static const CGFloat kPhotoHeight = 146/2;
static const CGFloat slide = 20/2;

@interface DetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) NSDictionary *activityData;
@property(nonatomic, strong) UICollectionView *photosView;
@property(nonatomic, strong) SKTagView *tagView;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _activityData = [[NSDictionary alloc] init];
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
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#f5f5f5"]];
    
    __weak typeof(self) weakSelf = self;
    self.title = @"活动详情";
    
    UIImageView *bg_imageView = [UIImageView new];
    bg_imageView.image =[UIImage imageNamed:@"center_bg"];
    [self.view addSubview:bg_imageView];
    [bg_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(380/2);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(PHONE_TOP_HEIGHT);
    }];
    
    //用户图像
    UIImageView *headerImageView = [UIImageView new];
    headerImageView.image = [UIImage imageNamed:@"sample_logo"];
    headerImageView.layer.cornerRadius = (kPhotoHeight) /2;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.userInteractionEnabled = YES;
    [self.view addSubview:headerImageView];
    
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32/2).offset(PHONE_TOP_HEIGHT + 10);
        make.width.height.mas_equalTo(kPhotoHeight);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *labelTextCollor = [UIColor colorFromHexString:@"#78441e"];
    
    
    UILabel *nicknameLabel = [UILabel new];
    nicknameLabel.text = @"董事长";
    nicknameLabel.textColor = labelTextCollor;
    nicknameLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImageView.mas_bottom).offset(24/2);
        make.right.mas_equalTo(self.view.mas_centerX).offset(-1);
    }];
    
    UIButton *sexAgeButton = [UIButton new];
    sexAgeButton.layer.cornerRadius = 3;
    sexAgeButton.layer.masksToBounds = YES;
    sexAgeButton.layer.borderColor = [UIColor colorFromHexString:@"#f16681"].CGColor;
    sexAgeButton.layer.borderWidth = 1;
    [sexAgeButton setImage:[UIImage imageNamed:@"sex_girl"] forState:UIControlStateNormal];
    [sexAgeButton setTitle:@" 18" forState:UIControlStateNormal];
    [sexAgeButton setTitleColor:[UIColor colorFromHexString:@"#f16681"] forState:UIControlStateNormal];
    sexAgeButton.titleLabel.font = font;
    [self.view addSubview:sexAgeButton];
    [sexAgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(76/2);
        make.top.mas_equalTo(headerImageView.mas_bottom).offset(24/2);
        make.centerY.mas_equalTo(nicknameLabel.mas_centerY);
        make.left.mas_equalTo(self.view.mas_centerX).offset(+1);
    }];
    
    
    UILabel *jobLabel = [UILabel new];
    jobLabel.text = @"巨蟹座 | 本科 | 商业/服务业/个体经营";
    jobLabel.font = font;
    jobLabel.textColor =labelTextCollor;
    jobLabel.textAlignment = NSTextAlignmentCenter;
    [weakSelf.view addSubview:jobLabel];
    [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nicknameLabel.mas_bottom).offset(24/2);
        make.left.right.mas_equalTo(weakSelf.view);
    }];
    
    SKTagView *tagView = [SKTagView new];
    tagView.padding    = UIEdgeInsetsMake(0, 0, 0, 0);
    tagView.insets    = 5;
    tagView.lineSpace = 5;
    self.tagView = tagView;
    [self.view addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jobLabel.mas_bottom).offset(24/2);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    //imgs
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [imgCollectionView setCollectionViewLayout:layout];
    imgCollectionView.dataSource = self;
    imgCollectionView.delegate = self;
    imgCollectionView.backgroundColor = [UIColor clearColor];
    //register cell
    [imgCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imgCollectionCell"];
    
    CGFloat imgHeight = (SCREEN_WIDTH - (4 * slide))/3;
    CGFloat imgViewHeight = (imgHeight*2) + slide;
    
    [self.view addSubview:imgCollectionView];
    [imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tagView.mas_bottom).offset(48/2);
        make.left.mas_equalTo(weakSelf.view).offset(slide);
        make.right.mas_equalTo(weakSelf.view).offset(-slide);
        make.height.mas_equalTo(imgViewHeight);
    }];
    
    UIView *address = [UIView new];
    address.layer.cornerRadius = 3;
    address.backgroundColor = [UIColor whiteColor];
    
    address.layer.masksToBounds = NO;
    address.layer.shadowColor =  [UIColor blackColor].CGColor;
    address.layer.shadowOffset = CGSizeMake(0, 1);
    address.layer.shadowOpacity = 0.1;
    address.layer.shadowRadius = 3;
    
    
    [self.view addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(72/2);
        make.left.mas_equalTo(weakSelf.view).offset(slide);
        make.right.mas_equalTo(weakSelf.view).offset(-slide);
        make.top.mas_equalTo(imgCollectionView.mas_bottom).offset(24/2);
    }];
}

- (void)setupTagView
{
    //Add Tags
    [@[@"电烧友", @"电影控", @"吃货", @"旅游达人"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
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
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imgView.layer.cornerRadius = 8;
    imgView.layer.borderWidth = 1;
    imgView.layer.borderColor = [UIColor colorFromHexString:@"#efefef"].CGColor;
    imgView.layer.masksToBounds = YES;
    imgView.backgroundColor = [UIColor clearColor];

    imgView.layer.masksToBounds = NO;
    imgView.layer.shadowColor =  [UIColor blackColor].CGColor;
    imgView.layer.shadowOffset = CGSizeMake(0, 1);
    imgView.layer.shadowOpacity = 1;
    imgView.layer.shadowRadius = 2;

    imgView.image = [UIImage imageNamed:@"sample_logo"];
    [cell addSubview:imgView];
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(cell);
//    }];
    
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
