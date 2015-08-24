//
//  IndexCollectionViewCell.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define SEXIMAGEWIDTH           11

#define kTagviewMarginTop       3
#define kTagPaddingTop          2
#define kTagPaddingBottom       3

#import "IndexCollectionViewCell.h"
#import <Masonry/Masonry.h>

#import "UIColor+colorBuild.h"

@implementation IndexCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
         __weak typeof(self) weakSelf = self;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.shadowColor =  [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 3;

        _userImageView = [UIImageView new];
        [self addSubview:_userImageView];
        [_userImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.height.width.mas_equalTo(weakSelf.contentView.bounds.size.width);
        }];
        
        _nicknameLabel = [UILabel new];
        _nicknameLabel.textColor = [UIColor colorFromHexString:@"#666666"];
        _nicknameLabel.textAlignment = NSTextAlignmentCenter;
        _nicknameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nicknameLabel];
        [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_userImageView.mas_bottom).offset(16/2);
            make.centerX.mas_equalTo(_userImageView.mas_centerX);
        }];
        
        UILabel *lineLabel = [UILabel new];
        lineLabel.text = @"|";
        lineLabel.font = [UIFont systemFontOfSize:12];
        lineLabel.textColor= [UIColor blackColor];
        [self addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.mas_equalTo(_userImageView.mas_centerX);
            make.top.mas_equalTo(_nicknameLabel.mas_bottom).offset(18/2);
        }];
        
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.textAlignment = NSTextAlignmentCenter;
        _ageLabel.textColor = [UIColor grayColor];
        _ageLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_ageLabel];
        [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineLabel);
            make.right.mas_equalTo(lineLabel.mas_left).offset(-(12/2));
        }];
        
        _sexLabel = [UILabel new];
        _sexLabel.backgroundColor = [UIColor clearColor];
        _sexLabel.font = [UIFont systemFontOfSize:12];
        _sexLabel.textColor = [UIColor colorFromHexString:@"#f15e76"];
        [self addSubview:_sexLabel];
        [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineLabel);
            make.right.mas_equalTo(_ageLabel.mas_left).offset(-(12/2));
        }];
        
        _constellation = [[UILabel alloc] init];
        _constellation.textColor = [UIColor lightGrayColor];
        _constellation.text = @"双鱼座";
        _constellation.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        _constellation.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_constellation];
        [_constellation mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineLabel);
            make.left.mas_equalTo(lineLabel.mas_right).offset(12/2);
        }];
        
        SKTagView *tagView = [SKTagView new];
        tagView.backgroundColor = [UIColor clearColor];
        tagView.padding = UIEdgeInsetsMake(3, tagViewRightPading ,3, tagViewLeftPading);
        tagView.insets = tagViewInserts;
        tagView.lineSpace = tagViewLineSpace;
        self.tagView = tagView;
        [self addSubview:tagView];
        [tagView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.mas_equalTo(_userImageView.mas_centerX);
            make.top.mas_equalTo(_sexLabel.mas_bottom).offset(12/2);
            make.left.mas_equalTo(weakSelf.mas_left);
            make.width.equalTo(weakSelf.mas_width);
        }];
        

        
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.backgroundColor = [UIColor clearColor];
        _locationImageView.image = [UIImage imageNamed:@"index_location"];
        [self addSubview:_locationImageView];
        [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_tagView.mas_bottom).offset(6);
            make.left.mas_equalTo(weakSelf.mas_left).offset(7);
            make.width.mas_equalTo(@16);
            make.height.mas_equalTo(@18);
        }];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.textColor = [UIColor lightGrayColor];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.text =@"12.5Km";
        _locationLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        [self addSubview:_locationLabel];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_tagView.mas_bottom).offset(8);
            make.left.mas_equalTo(_locationImageView.mas_right).offset(4);
        }];
    
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"10分钟前";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        _timeLabel.textColor= [UIColor lightGrayColor];
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make){

            
            make.top.mas_equalTo(_tagView.mas_bottom).offset(8);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-6);
        }];
        
        _timeImageView = [UIImageView new];
        _timeImageView.image = [UIImage imageNamed:@"index_time"];
        [self addSubview:_timeImageView];
        [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_tagView.mas_bottom).offset(6);
            make.right.mas_equalTo(_timeLabel.mas_left).offset(-6);
            make.width.mas_equalTo(@15);
            make.height.mas_equalTo(@16);
        }];
    }
    
    return self;
};
@end
