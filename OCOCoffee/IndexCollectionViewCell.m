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
        _photo = [[UIImageView alloc] init];
        _photo.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        _photo.clipsToBounds = YES;
        [self.contentView addSubview:_photo];
    }
    
    return self;
}

@end
