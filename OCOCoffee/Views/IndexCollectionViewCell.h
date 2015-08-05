//
//  IndexCollectionViewCell.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexCollectionViewCell : UICollectionViewCell


@property(strong,nonatomic) UIImageView *userImageView;
@property(strong,nonatomic) UILabel    *usernameLabel;
@property(strong,nonatomic) UIImageView *sexImageView;
@property(strong,nonatomic) UILabel    *ageLabel;
@property(strong,nonatomic) UILabel    *constellation;//星座
@property(strong,nonatomic) NSArray     *tagLabel;
@property(strong,nonatomic) UIImageView *locationImageView;
@property(strong,nonatomic) UILabel    *locationLabel;
@property(strong,nonatomic) UIImageView *timeImageView;
@property(strong,nonatomic) UILabel    *timeLabel;


@end
