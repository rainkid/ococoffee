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
    if( self = [super initWithFrame:frame]){
         __weak typeof(self) weakSelf = self;
        
        UIView *view1 = [UIView new];
        view1.backgroundColor = [UIColor whiteColor];
        view1.layer.cornerRadius = 3;
        view1.layer.masksToBounds = YES;
        [self.contentView addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(weakSelf.contentView);
            make.size.mas_equalTo(self.contentView.bounds.size);
            
        }];
        
        long kMainImageHeight = self.contentView.bounds.size.height- 108;
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
        
         _tagView = [SKTagView new];
        _tagView.backgroundColor = [UIColor clearColor];
        _tagView.padding = UIEdgeInsetsMake(kTagviewMarginTop,3 ,0, 3);
        _tagView.insets = 5;
        _tagView.lineSpace = 2;
        [self addSubview:_tagView];
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_sexImageView.mas_bottom).offset(3.6);
            make.left.mas_equalTo(weakSelf.mas_left).offset(5);
            make.width.equalTo(weakSelf.mas_width);
        }];
        
        
        NSMutableArray *tagValues = [self getRandTags];
        [tagValues enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
            
            SKTag *tag          = [SKTag tagWithText:obj];
            tag.textColor       = [UIColor whiteColor];
            tag.cornerRadius    = 2;
            tag.borderWidth     = 0;
             NSString *colorStr  = [self randColor];
            tag.bgColor         = [UIColor colorFromHexString:colorStr];
            
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:11.0];
            tag.font            = font;
            tag.padding         = UIEdgeInsetsMake(kTagPaddingTop, kTagPaddingTop, kTagPaddingBottom, kTagPaddingBottom);
            CGSize size = CGSizeMake(80, 20);
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
            size = [tag.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
            float Height = size.height;
            float rowHeight = Height + kTagPaddingBottom + kTagPaddingTop;
            _tagRowHeight = [[NSNumber alloc] initWithFloat:rowHeight];
            _tagCounts =  [[NSNumber alloc] initWithInteger:[tagValues count]];
            [_tagView addTag:tag];
        }];
        
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.backgroundColor = [UIColor clearColor];
        _locationImageView.image = [UIImage imageNamed:@"location"];
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
        
        _timeImageView = [[UIImageView alloc] init];
        _timeImageView.image = [UIImage imageNamed:@"time"];
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



-(NSMutableArray *)getRandTags {
    NSArray *tmp = @[@"逛街",@"购物狂",@"科技达人",@"cosplay",@"爱音乐",@"电影迷",@"户外运动",@"阅读"];
    
    NSMutableArray *tags = [[NSMutableArray alloc] initWithArray:tmp];

     NSUInteger total = [tags count];
    int rand = ( arc4random() % (total - 1)) + 1;
    for (int i = 0; i< total ; i++) {
        [tags exchangeObjectAtIndex:i withObjectAtIndex:rand];
    }
    
    NSMutableArray *randTags = [[NSMutableArray alloc] initWithCapacity:5];
    int num = (arc4random() % 5) + 1 ;
    for (int j=0; j < num ; j++) {
        [randTags addObject:tags[j]];
    }
    return randTags;
}

-(NSString *)randColor{
     NSArray *colorList = @[@"#fab965",@"#a7c5e7",@"#ffa99c",@"#a5dbdb",@"#b3de5d"];
    NSMutableArray *mutlist = [[NSMutableArray alloc] initWithArray:colorList];
    int rand = (arc4random() % ([mutlist count] -1) +1);
    for (int i = 0; i< [mutlist count]; i++) {
        [mutlist exchangeObjectAtIndex:i withObjectAtIndex:rand];
    }
    int index  = (arc4random() % 5);
    NSString *color = [colorList objectAtIndex: index];
    return color;
}
@end
