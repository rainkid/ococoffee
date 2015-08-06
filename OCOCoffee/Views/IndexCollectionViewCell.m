//
//  IndexCollectionViewCell.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "IndexCollectionViewCell.h"

@implementation IndexCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame]){
    
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 120)];
        _userImageView.backgroundColor = [UIColor blueColor];
        
        [self.contentView addSubview: _userImageView];
        
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 123, 30, 20)];
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
        _usernameLabel.font = [UIFont fontWithName:@"Heceriva" size:12.0];
        [self.contentView addSubview:_usernameLabel];
        
        _sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 123, 30, 20)];
        _sexImageView.image = [UIImage imageNamed:@"001"];
        [self.contentView addSubview:_sexImageView];
    }
    
    return self;
}

@end
