//
//  DetailViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/13.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//
#import "Global.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import "ActivityDetailViewController.h"
#import <SKTagView/SKTagView.h>


static const CGFloat kPhotoHeight = 146/2;
static const CGFloat slide = 20/2;
static const CGFloat buttonHeight = 106/2;

@interface ActivityDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) NSDictionary *activityData;

@property(nonatomic, strong) SKTagView *tagView;

@property(nonatomic, strong) UIButton *upButton;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *centerView;
@property(nonatomic, strong) UICollectionView *imgCollectionView;

@end



@implementation ActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _activityData = [[NSDictionary alloc] init];
        self.hidesBottomBarWhenPushed = YES;
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
    self.title = @"活动详情";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#f5f5f5"]];

    
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *labelTextCollor = [UIColor colorFromHexString:@"#888888"];
    
    UIScrollView *scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.scrollEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        [scrollView setContentOffset:CGPointZero animated:YES];
        scrollView.contentSize = CGSizeMake(weakSelf.view.frame.size.width, weakSelf.view.frame.size.height + buttonHeight);
        scrollView;
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
        imageView.image = [UIImage imageNamed:@"sample_logo"];
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
    
    
    UILabel *nicknameLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"董事长";
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
        label.text = [NSString stringWithFormat:@" %@%@ ", @"♀", @"18"];
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
        label.text = @"巨蟹座 | 本科 | 商业/服务业/个体经营";
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
        SKTagView *tagView = [SKTagView new];
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
    
    UIView *centerView = [UIView new];
    centerView.backgroundColor = [UIColor whiteColor];
    self.centerView = centerView;
    [scrollView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [centerView addSubview:self.imgCollectionView];
    [self.imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tagView.mas_bottom).offset(24/2);
        make.left.mas_equalTo(centerView).offset(slide);
        make.right.mas_equalTo(centerView).offset(-slide);
        make.height.mas_equalTo(imgCollectionViewHeight);
    }];
    
    UIView *addressView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
        view.layer.masksToBounds = NO;
        view.layer.shadowColor =  [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(1, 1);
        view.layer.shadowOpacity = 0.1;
        view.layer.shadowRadius = 1;
        view;
    });
    [centerView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(72/2);
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
    
    UILabel *addressLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"阳光高尔夫大厦";
        label.font = font;
        label.textColor = [UIColor colorFromHexString:@"#aeaeae"];
        label;
    });
    [addressView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressImgView.mas_right).offset(24/2);
        make.centerY.mas_equalTo(addressView);
    }];
    
    UILabel *lonsLabel = ({
        UILabel *label =[UILabel new];
        label.text = @"0.54km  刚刚";
        label.font = font;
        label.textColor = labelTextCollor;
        label;
    });
    [addressView addSubview:lonsLabel];
    [lonsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(addressView.mas_right).offset(-(24/2));
        make.centerY.mas_equalTo(addressView);
    }];
    
    [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(addressView.mas_bottom).offset(24/2);
    }];

    //botview
    UIView *botView = [UIView new];
    botView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:botView];
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(330/2);
        make.width.mas_equalTo(scrollView);
        make.top.mas_equalTo(centerView.mas_bottom).offset(30/2);
    }];
    
    UILabel *botLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = labelTextCollor;
        label.text = @"详细信息";
        label.font = font;
        label;
    });
    [botView addSubview:botLabel];
    [botLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(62/2);
        make.width.top.mas_equalTo(botView);
        make.height.mas_equalTo(62/2);
    }];
    
    UIView *botSplit = [UIView new];
    botSplit.backgroundColor = [UIColor colorFromHexString:@"#8f413b"];
    [botLabel addSubview:botSplit];
    [botSplit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28/2);
        make.width.mas_equalTo(12/2);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(20/2);
        make.centerY.mas_equalTo(botLabel.mas_centerY);
    }];
    
    UIImageView *coffeeTimeImageView = [UIImageView new];
    coffeeTimeImageView.image = [UIImage imageNamed:@"center_time"];
    [botView addSubview:coffeeTimeImageView];
    [coffeeTimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(botLabel.mas_bottom).offset(14/2);
        make.left.mas_equalTo(weakSelf.view).offset(28/2);
    }];
    
    UILabel *coffeeTimeLabel =({
        UILabel *label = [UILabel new];
        label.text = @"7月15日周一下午1:00";
        label.font = font;
        label.textColor = labelTextCollor;
        label;
    });
    [botView addSubview:coffeeTimeLabel];
    [coffeeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(coffeeTimeImageView);
        make.left.mas_equalTo(coffeeTimeImageView.mas_right).offset(28/2);
    }];
    
    UIImageView *coffeeAddressImageView = [UIImageView new];
    coffeeAddressImageView.image = [UIImage imageNamed:@"center_address"];
    [botView addSubview:coffeeAddressImageView];
    [coffeeAddressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coffeeTimeLabel.mas_bottom).offset(30/2);
        make.left.mas_equalTo(coffeeTimeImageView);
    }];
    
    UILabel *coffeeAddressLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"深圳福田深南大道700号深圳福田深南大道700号深圳福田深南大道700号深圳福田深南大道700号";
        label.font = font;
        label.textColor = labelTextCollor;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.numberOfLines = 0;
        label;
    });
    [botView addSubview:coffeeAddressLabel];
    [coffeeAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH - (208/2));
        make.top.mas_equalTo(coffeeAddressImageView.mas_top);
        make.left.mas_equalTo(coffeeTimeLabel);
    }];
    
    UIImageView *coffeeDescImageView = [UIImageView new];
    coffeeDescImageView.image = [UIImage imageNamed:@"center_address"];
    [botView addSubview:coffeeDescImageView];
    [coffeeDescImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coffeeAddressLabel.mas_bottom).offset(30/2);
        make.left.mas_equalTo(coffeeAddressImageView);
    }];
    
    UILabel *coffeeDescLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"这里是描述";
        label.font = font;
        label.textColor = labelTextCollor;
        label;
    });
    [botView addSubview:coffeeDescLabel];
    [coffeeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coffeeDescImageView.mas_top);
        make.left.mas_equalTo(coffeeAddressLabel);
    }];
    
    CGFloat sliceWidth = SCREEN_WIDTH/4;
    UIButton *refuseButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:@"拒绝" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:labelTextCollor forState:UIControlStateNormal];
        button;
    });
    [scrollView addSubview:refuseButton];
    [refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(sliceWidth);
        make.height.mas_equalTo(buttonHeight);
        make.left.mas_equalTo(weakSelf.view.mas_left);
    }];
    
    UIButton *cancelButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:labelTextCollor forState:UIControlStateNormal];
        button;
    });
    [scrollView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sliceWidth);
        make.top.height.mas_equalTo(refuseButton);
        make.left.mas_equalTo(refuseButton.mas_right);
    }];
    
    UIButton *acceptButton = ({
        UIButton *button = [UIButton new];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"接受" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorFromHexString:@"#b8524a"];
        button;
    });
    [scrollView addSubview:acceptButton];
    [acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view);
        make.top.height.mas_equalTo(refuseButton);
        make.left.mas_equalTo(cancelButton.mas_right);
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
    SKTag *tag = ({
        SKTag *tag = [SKTag tagWithText:obj];
        tag.textColor = [UIColor blackColor];
        tag.bgColor = [UIColor colorFromHexString:@"#ffa99c"];
        tag.cornerRadius = 3;
        tag.fontSize = 13;
        tag.padding = UIEdgeInsetsMake(4, 10, 4, 10);
        tag;
    });
    
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
