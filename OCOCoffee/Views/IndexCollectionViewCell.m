//
//  IndexCollectionViewCell.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define SEXIMAGEWIDTH 11

#import "IndexCollectionViewCell.h"
#import <Masonry/Masonry.h>

@implementation IndexCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame]){
         __weak typeof(self) weakSelf = self;
        
        UIView *view1 = [UIView new];
        view1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        [self.contentView addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(weakSelf.contentView);
            make.size.mas_equalTo(self.contentView.bounds.size);
            
        }];
        
        long kMainImageHeight = self.contentView.bounds.size.height- 85;
        _userImageView = [UIImageView new];
        _userImageView.backgroundColor = [UIColor redColor];
        [view1 addSubview:_userImageView];
        [_userImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.mas_equalTo(view1.mas_centerX);
            make.height.mas_equalTo(kMainImageHeight);
            make.width.mas_equalTo(self.contentView.bounds.size.width);
            
        }];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.textColor = [UIColor brownColor];
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
        _usernameLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        [self.contentView addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_userImageView.mas_bottom).offset(3.0);
            make.centerX.mas_equalTo(weakSelf.contentView);
            
        }];
        
        
        
        UIImageView *backGroudView = [[UIImageView alloc] init];
        backGroudView.image = [UIImage imageNamed:@"background"];
        backGroudView.backgroundColor= [UIColor clearColor];
        [self addSubview:backGroudView];
        [backGroudView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_usernameLabel.mas_bottom).offset(4.2);
            make.centerX.mas_equalTo(weakSelf);
            make.width.mas_equalTo(@1);
            make.height.mas_equalTo(@12);
        }];
        
        
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.text = @"20";
        _ageLabel.textAlignment = NSTextAlignmentCenter;
        _ageLabel.textColor = [UIColor grayColor];
        _ageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        [self addSubview:_ageLabel];
        [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_usernameLabel.mas_bottom).offset(3.6);
            make.right.mas_equalTo(backGroudView.mas_left).offset(-12);
        }];
        
        _sexImageView = [[UIImageView alloc] init];
        _sexImageView.backgroundColor = [UIColor clearColor];
        _sexImageView.image = [UIImage imageNamed:@"woman"];
        [self addSubview:_sexImageView];
        [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_usernameLabel.mas_bottom).offset(4.5);
            make.width.mas_equalTo(SEXIMAGEWIDTH);
            make.height.mas_equalTo(SEXIMAGEWIDTH);
            make.right.mas_equalTo(_ageLabel.mas_left).offset(-8);
        }];
        
        _constellation = [[UILabel alloc] init];
        _constellation.textColor = [UIColor lightGrayColor];
        _constellation.text = @"双鱼座";
        _constellation.font=[UIFont fontWithName:@"Helvetica" size:14.0];
        _constellation.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_constellation];
        [_constellation mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_usernameLabel.mas_bottom).offset(3.6);
            make.left.mas_equalTo(backGroudView.mas_right).offset(13);
            
        }];
        
        UILabel *tagLabel1 = [[UILabel alloc] init];
        tagLabel1.backgroundColor = [UIColor purpleColor];
        tagLabel1.layer.cornerRadius = 2;
        tagLabel1.text = @"阅读控";
        tagLabel1.textAlignment = NSTextAlignmentCenter;
        tagLabel1.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        tagLabel1.textColor = [UIColor whiteColor];
        [self addSubview:tagLabel1];
        [tagLabel1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_sexImageView.mas_bottom).offset(3.5);
            make.left.mas_equalTo(weakSelf.mas_left).offset(6);
            make.width.mas_equalTo(@48);
            make.height.mas_equalTo(@15);
        }];
        
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.backgroundColor = [UIColor clearColor];
        _locationImageView.image = [UIImage imageNamed:@"location"];
        [self addSubview:_locationImageView];
        [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(tagLabel1.mas_bottom).offset(6);
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
            make.top.mas_equalTo(tagLabel1.mas_bottom).offset(8);
            make.left.mas_equalTo(_locationImageView.mas_right).offset(4);
        }];
        
    
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"10分钟前";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        _timeLabel.textColor= [UIColor lightGrayColor];
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(tagLabel1.mas_bottom).offset(8);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-6);
        }];
        
        _timeImageView = [[UIImageView alloc] init];
        _timeImageView.image = [UIImage imageNamed:@"time"];
        [self addSubview:_timeImageView];
        [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(tagLabel1.mas_bottom).offset(6);
            make.right.mas_equalTo(_timeLabel.mas_left).offset(-6);
            make.width.mas_equalTo(@15);
            make.height.mas_equalTo(@16);
            
        }];
        
//        UIView *view2 = [UIView new];
//        view2.backgroundColor = [UIColor whiteColor];
//        [view1 addSubview:view2];
//        [view2 mas_makeConstraints:^(MASConstraintMaker *make){
//            make.centerX.mas_equalTo(view1.mas_centerX);
//            make.width.mas_equalTo(@60);
//            make.top.mas_equalTo(_userImageView.bounds.size.height);
//            
//        }];
//        
//        _usernameLabel = [UILabel new];
//        _usernameLabel.backgroundColor = [UIColor clearColor];
//        [view2 addSubview:_usernameLabel];
//        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make){
//            make.centerX.mas_equalTo(view2.mas_centerX);
//            make.width.equalTo(@100);
//            make.height.equalTo(@20);
//            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(5, 0, 0, 0));
//        }];
//        
//
//        UIView *view3 = [UIView new];
//        view3.backgroundColor = [UIColor whiteColor];
//        [view2 addSubview:view3];
//        [view3 mas_makeConstraints:^(MASConstraintMaker *make){
//            make.centerX.mas_equalTo(view2.mas_centerX);
//            make.top.equalTo(view2.mas_top).with.offset(3);
//            make.bottom.equalTo(view2.mas_bottom).with.offset(-3);
//            make.width.equalTo(view2);
//            make.height.mas_equalTo(@20);
//        }];
//        
//        _sexImageView = [UIImageView new];
//        [view3 addSubview:_sexImageView];
//        [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make){
//            make.width.mas_equalTo(@10);
//            
//        }];
//        
//        _ageLabel = [[UILabel alloc] init];
//        _ageLabel.backgroundColor=[UIColor whiteColor];
//        _ageLabel.text = @"20";
//        _ageLabel.textAlignment = NSTextAlignmentCenter;
//        _ageLabel.font = [UIFont fontWithName:@"Haviera" size:12.0];
//        _ageLabel.textColor = [UIColor redColor];
//        [view3 addSubview:_ageLabel];
//        [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make){
//            
//        }];
//        
//        _constellation = [UILabel new];
//        _constellation.backgroundColor = [UIColor whiteColor];
//        _constellation.text = @"双鱼座";
//        _constellation.textColor = [UIColor orangeColor];
//        _constellation.textAlignment = NSTextAlignmentCenter;
//        [view3 addSubview:_constellation];
//        [_constellation mas_makeConstraints:^(MASConstraintMaker *make){
//            
//        }];
//    
//        UIView *view4 = [UIView new];
//        view4.backgroundColor = [UIColor whiteColor];
//        [view2 addSubview:view4];
//        [view4 mas_makeConstraints:^(MASConstraintMaker *make){
//            
//        }];
//        
//        UIView *view5 = [UIView new];
//        view5.backgroundColor = [UIColor clearColor];
//        [view2 addSubview:view5];
//        [view5 mas_makeConstraints:^(MASConstraintMaker *make){
//            
//        }];
//        
//        UIImageView *locImageview = [[UIImageView alloc]init];
//        locImageview.backgroundColor = [UIColor clearColor];
//        locImageview.image = [UIImage imageNamed:@"location"];
//        [view5 addSubview:locImageview];
//        [locImageview mas_makeConstraints:^(MASConstraintMaker *make){
//            
//        }];
//        
//        UILabel *locLabel = [[UILabel alloc] init];
//        locLabel.backgroundColor = [UIColor clearColor];
//        [view5 addSubview:locLabel];
//        [locLabel mas_makeConstraints:^(MASConstraintMaker *make){
//        
//        }];
//        
//        
//        UIImageView *loginImageView = [[UIImageView alloc]init];
//        loginImageView.backgroundColor = [UIColor clearColor];
//        loginImageView.image = [UIImage imageNamed:@"time"];
//        [view5 addSubview:loginImageView];
//        [loginImageView mas_makeConstraints:^(MASConstraintMaker *make){
//            
//        }];
//        
//        UILabel *loginLabel = [[UILabel alloc] init];
//        loginLabel.backgroundColor = [UIColor clearColor];
//        [view5 addSubview:loginLabel];
//        [loginLabel mas_makeConstraints:^(MASConstraintMaker *make){
//            
//        }];
        
    }
    
    return self;
};

@end
