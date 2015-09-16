//
//  CenterHeaderCell.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/14.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kimageCollectionViewCell  @"imageCollectioinViewCell"
#define kButtonTag                100

#import "CenterHeaderCell.h"
#import <Masonry/Masonry.h>
#import "Global.h"
#import "InfoCollectionCell.h"

static const CGFloat kPhotoHeight = 82;

@implementation CenterHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initCellView];
    }
    
    return  self;
}


-(void)initCellView {
    
    __weak typeof(self) weakSelf = self;
    
    UIImageView *bg_imageView = [UIImageView new];
    bg_imageView.image =[UIImage imageNamed:@"center_bg"];
    [weakSelf.contentView addSubview:bg_imageView];
    [bg_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(230/2);
        make.top.mas_equalTo(weakSelf.mas_top).offset(0);
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
    [weakSelf.contentView addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.height.and.width.mas_equalTo(kCPhotoHeight);
        make.top.mas_equalTo(bg_imageView.mas_top).offset(3);
    }];
    
    _headImageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.layer.cornerRadius = (kPhotoHeight) /2;
       // [imageView sd_setImageWithURL:[NSURL URLWithString:_[@"headimgurl"]]];
        imageView.layer.masksToBounds = YES;
        imageView;
    });
    
    [weakSelf.contentView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(photoView.mas_top).offset(kPhotoSlide/2);
        make.height.and.width.mas_equalTo(kPhotoHeight);
    }];
    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editImage:)];
    [_headImageView addGestureRecognizer:tap];
    
    UIImageView *cameraView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"regis_camera"];
        imageView;
        
    });
    [weakSelf.contentView addSubview:cameraView];
    [cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(photoView.mas_top).offset(60);
        make.centerX.mas_equalTo(photoView).offset(30);
    }];
    
    
    UIView *tagView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    [weakSelf.contentView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(bg_imageView.mas_bottom).offset(6);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(5);
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
        [button setTag:kButtonTag];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [tagView addSubview:statusBtn];
    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(tagView.mas_right).offset(-17);
        make.top.mas_equalTo(tagView.mas_top).offset(2);
        make.bottom.mas_equalTo(tagView.mas_bottom).offset(7);
        make.width.mas_equalTo(@52);
    }];
    

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _imgCollectionView.backgroundColor = [UIColor whiteColor];
        _imgCollectionView.tag = 111;
        [_imgCollectionView registerClass:[InfoCollectionCell class] forCellWithReuseIdentifier:kimageCollectionViewCell];

    
    [weakSelf.contentView addSubview:_imgCollectionView];
    [_imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(tagView.mas_bottom).offset(15);
        make.left.mas_equalTo(weakSelf.mas_left).offset(5);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-5);
        //make.height.mas_equalTo(@225);
    }];

}

-(void)editImage:(UITapGestureRecognizer *)tap {
    [self.delegate changeHeadImage:tap];
}

-(void)save:(UIButton *)button {
    
    [self.delegate savePhoto:button];
}
@end
