//
//  IndexCollectionViewCell.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKTagView/SKTagView.h>

const static CGFloat KCollectionItemBotHeight = 200/2;

const static CGFloat tagViewLeftPading = 5;
const static CGFloat tagViewRightPading = 5;

const static CGFloat tagItemRightPading = 3;
const static CGFloat tagItemLeftPading = 3;

const static CGFloat tagViewLineSpace = 5;
const static CGFloat tagViewInserts = 5;

@interface IndexCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic) UIImageView *userImageView;
@property(strong,nonatomic) UILabel    *nicknameLabel;
@property(strong,nonatomic) UILabel    *sexLabel;
@property(strong,nonatomic) UILabel    *ageLabel;
@property(strong,nonatomic) UILabel    *constellation;//星座
@property(strong,nonatomic) NSArray     *tagLabel;
@property(strong,nonatomic) UIImageView *locationImageView;
@property(strong,nonatomic) UILabel    *locationLabel;
@property(strong,nonatomic) UIImageView *timeImageView;
@property(strong,nonatomic) UILabel    *timeLabel;
@property(strong,nonatomic) SKTagView   *tagView;

@property(strong,nonatomic) NSNumber *tagRowHeight;
@property(strong,nonatomic) NSNumber *tagCounts;

@end
