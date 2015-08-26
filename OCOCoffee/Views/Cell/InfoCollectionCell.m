//
//  InfoViewCollectionCell.m
//  OCOCoffee
//
//  Created by sam on 15/8/26.
//  Copyright (c) 2015年 sam. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "InfoCollectionCell.h"

@implementation InfoCollectionCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;
        
        self.layer.shadowColor =  [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 3;
        
        self.imageView =({
            UIImageView * imageView = [UIImageView new];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 3;
            imageView;
        });
        
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(weakSelf);
        }];
    }
    return self;
}

@end
