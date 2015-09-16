//
//  EditViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/13.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kimageCollectionViewCell  @"imageCollectioinViewCell"
#define kImageListURL             @"api/userimg/list"

#import "EditViewController.h"
#import "ViewStyles.h"
#import "Global.h"
#import "LoginViewController.h"
#import "InfoCollectionCell.h"
#import "Common.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>

static const CGFloat kPhotoHeight = 82;
static const CGFloat kPadding = 10;

@interface EditViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate>{
    
    UIImagePickerController *_imagePicker;
    UITableView *_tableView;
    UICollectionView *_collectionView;
    NSMutableArray *imgArr,*imgList;
    UIImageView *headImageView;
    NSInteger status;
    UIScrollView *scrollView;
    
    MWPhoto *photo;
    MWPhotoBrowser *photoBrwser;
}

@end

@implementation EditViewController

-(void)viewDidLoad {
    
    //[self checkLogin];
    
    [ViewStyles setNaviControllerStyle:self.navigationController];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(returnBack)
                                   ];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.title = @"个人资料";
    
    [self initView];
//    if(imgArr == nil){
//        [self loadImgsFromServer];
//    }
}
-(void)loadImgsFromServer {
    
    imgArr = [[NSMutableArray alloc] initWithCapacity:6];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kImageListURL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id obj){
       if(obj[@"data"] !=nil && [obj[@"data"][@"imgs"] isKindOfClass:[NSArray class]]){
           [imgArr addObjectsFromArray:obj[@"data"][@"imgs"]];
           [_collectionView reloadData];
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error);
    }];
}


-(void)getUserImageList:(NSArray *)dataList {
    for (NSDictionary *dict in dataList) {
        [imgArr addObject:dict[@"img"]];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:dict[@"img"]]];
        [imgList addObject:photo];
    }
    
}

-(void)checkLogin
{
    if([Common userIsLogin]) {
        [self showLoginPage];
    } else {
       //[self loadDataFromServer];
    }
}

-(void) showLoginPage
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    //loginViewController.delegate = self;
    [self.parentViewController presentViewController:loginViewController animated:YES completion:nil];
}

-(void)returnBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"completed");
    }];
}
-(void)initView {
    __weak typeof(self) weakSelf = self;
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator  = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-PHONE_NAVIGATIONBAR_HEIGHT-PHONE_STATUSBAR_HEIGHT);
    scrollView.contentOffset = CGPointZero;
    scrollView.userInteractionEnabled  = YES;
    scrollView.contentInset = UIEdgeInsetsMake(20, 0, 30, 0);
    [self.view addSubview:scrollView];
    
    UIImageView *bg_imageView = [UIImageView new];
    bg_imageView.image =[UIImage imageNamed:@"center_bg"];
    [scrollView addSubview:bg_imageView];
    [bg_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(230/2);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(PHONE_TOP_HEIGHT);
    }];
    
    //photo cyctle
    long kPhotoSlide = 8;
    long kCPhotoHeight =kPhotoHeight+kPhotoSlide;
    UIView *photoView = [UIView new];
    photoView.layer.cornerRadius = kCPhotoHeight/2;
    photoView.layer.masksToBounds = YES;
    photoView.layer.borderWidth = 1.0f;
    photoView.layer.borderColor = [UIColor whiteColor].CGColor;
    photoView.alpha = 0.9;
    [self.view addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.and.width.mas_equalTo(kCPhotoHeight);
        make.top.mas_equalTo(bg_imageView.mas_top).offset(3);
    }];
    
    headImageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.layer.cornerRadius = (kPhotoHeight) /2;
       [imageView sd_setImageWithURL:[NSURL URLWithString:_userDict[@"headimgurl"]]];
        imageView.layer.masksToBounds = YES;
        imageView;
    });
    
    [scrollView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(photoView.mas_top).offset(kPhotoSlide/2);
        make.height.and.width.mas_equalTo(kPhotoHeight);
    }];
    headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage:)];
    [headImageView addGestureRecognizer:tap];
    
    UIImageView *cameraView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"regis_camera"];
        imageView;
        
    });
    [scrollView addSubview:cameraView];
    [cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(photoView.mas_top).offset(60);
        make.centerX.mas_equalTo(photoView).offset(30);
    }];
    
    
    UIView *tagView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    [scrollView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(bg_imageView.mas_bottom).offset(6);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(10);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(5);
        make.height.mas_equalTo(@20);
    }];

    UIImageView *tagImage = ({
        UIImageView *imageview = [UIImageView new];
        imageview.image = [UIImage imageNamed:@"col"];
        imageview.backgroundColor = [UIColor clearColor];
        imageview;
    });
    
    [tagView addSubview:tagImage];
    [tagImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(tagView.mas_left).offset(0);
        make.top.mas_equalTo(tagView.mas_top).offset(2);
        make.bottom.mas_equalTo(tagView.mas_bottom);
        make.width.mas_equalTo(@4);
    }];
    
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [tagView addSubview:titleLabel];
    
    NSDictionary *firstWords = @{
                                 NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:14.0],
                                 NSForegroundColorAttributeName:[UIColor blackColor],
                                 };
    NSDictionary *secondWords = @{
                                  NSFontAttributeName :[UIFont fontWithName:@"Helvetica" size:12.0],
                                  NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                  };
    
    NSString *tipString = [NSString stringWithFormat:@"%@ (%@)",@"生活照片",@"你可以上传6张生活照片"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tipString];
    [attributedString setAttributes:firstWords range:NSMakeRange(0, 4)];
    [attributedString setAttributes:secondWords range:NSMakeRange(4, tipString.length - 4)];
    titleLabel.attributedText = attributedString;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(tagImage.mas_right).offset(5);
        make.right.mas_equalTo(tagView.mas_right).offset(100);
        make.top.mas_equalTo(tagView.mas_top).offset(2);
        make.bottom.mas_equalTo(tagView.mas_bottom).offset(1);
    }];
    
    UIButton *statusBtn = ({
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"编 辑" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(editImage:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [tagView addSubview:statusBtn];
    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(tagView.mas_right).offset(-17);
        make.top.mas_equalTo(tagView.mas_top).offset(2);
        make.bottom.mas_equalTo(tagView.mas_bottom).offset(7);
        make.width.mas_equalTo(@52);
    }];
    
    
    if(_collectionView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[InfoCollectionCell class] forCellWithReuseIdentifier:kimageCollectionViewCell];
    }
    
    [scrollView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(tagView.mas_bottom).offset(15);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(5);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-5);
        make.height.mas_equalTo(@225);
    }];
    
    _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            tableView.backgroundColor = [UIColor lightGrayColor];
           // [tableView setScrollEnabled:YES];
            [tableView setScrollEnabled:NO];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView;
        });
        
    [scrollView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(3);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(3);
        make.top.mas_equalTo(_collectionView.mas_bottom).offset(10);
        make.height.mas_equalTo(@300);
    }];
    
   // scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"start scroll");
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString static *identifier = kimageCollectionViewCell;
    InfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"sample_p"];
//    NSInteger row = [indexPath row];
//    NSDictionary *dict = [imgArr objectAtIndex:row];
//    if(dict != nil){
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]]];
    //}
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SCREEN_WIDTH - (4 * kPadding))/3;
    return CGSizeMake(width, width);
}

#pragma tableview datasource mehtods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 7;
    }else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"kTableViewIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSInteger section = [indexPath section];
    if(section == 0){
        cell.textLabel.text = @"test";
    }else{
        cell.textLabel.text = @"section2";
    }
    return cell;
}

-(void)changeHeadImage:(UITapGestureRecognizer *)tap {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"拍照"
                                                    otherButtonTitles:@"相册中选取",@"图库中选取",
                                  nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Selected:%ld",(long)buttonIndex);
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
            
        case 1:
            [self pickFromAlbum];
            break;
        case 2:
            [self pickFromGallery];
            break;
            
        default:
            break;
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet {
    NSLog(@"cancel sheet");
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"dismiss_%ld",buttonIndex);
}


//拍照
-(void)takePhoto {
    NSLog(@"take photo");
    if(![self isCameraAvailable]){
        [Common showErrorDialog:@"无法使用相机"];
    }else{
        if(_imagePicker == nil){
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate       = self;
            _imagePicker.sourceType     = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.allowsEditing  = YES;
        }
        [self presentViewController:_imagePicker animated:YES completion:^(void){
            NSLog(@"开始拍照");
        }];
    }
}

//相册中选择
-(void)pickFromAlbum {
    if(_imagePicker == nil){
        NSLog(@"pick from album");
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate       = self;
    }
    _imagePicker.sourceType     = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
}
//图库中选择
-(void)pickFromGallery {
    if(_imagePicker == nil){
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

//摄像头是否可用
-(BOOL)isCameraAvailable {
    
    return [UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

//前摄像头是否可用
-(BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
//后摄像头是否可用
-(BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


//是否支持拍照
-(BOOL)isSupportTakingPhoto {
    return [self canSupportMedia:(NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

//是否支持摄像
-(BOOL)isSupportShottingVideo {
    return [self canSupportMedia:(NSString *)kUTTypeVideo sourceType:UIImagePickerControllerSourceTypeCamera];
}

//是否支持某一种媒体操作
-(BOOL)canSupportMedia:(NSString *)mediaType sourceType:(UIImagePickerControllerSourceType)sourceType {
    __block BOOL result = NO;
    if(mediaType.length == 0){
        return NO;
    }
    NSArray *availTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    [availTypes enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        
        NSString *selectedeida = obj;
        if([selectedeida isEqualToString:mediaType]){
            result = YES;
            *stop  = YES;
        }
    }];
    
    return result;
}


#pragma imagepickerController delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    headImageView.image = image;
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)editImage:(UIButton *)button {
    button.layer.borderColor = [UIColor redColor].CGColor;
    [button setTitle:@"完 成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
}
@end