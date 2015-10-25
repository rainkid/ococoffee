//
//  InfoViewCollectionCell.m
//  OCOCoffee
//
//  Created by sam on 15/8/26.
//  Copyright (c) 2015年 sam. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "UIColor+colorBuild.h"
#import "InfoCollectionCell.h"

@interface InfoCollectionCell (){
    UIButton *btn;
}

@end

@implementation InfoCollectionCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;
        
        self.layer.shadowColor =  [UIColor blackColor].CGColor;
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 3;
        
        self.imageView =({
            UIImageView * imageView = [UIImageView new];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 3;
            imageView.tag = 211;
            imageView;
        });
        
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf);
            make.width.height.mas_equalTo(weakSelf);
        }];
        
        _deleteImageView = ({
            //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete"]];
            UIImageView *imageView = [UIImageView new];
            btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [btn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(clearImage:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.hidden = YES;
            imageView.tag = 212;
            imageView.layer.cornerRadius = 5;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearImage:)];
//            [imageView addGestureRecognizer:tap];
            imageView;
        });
        [self addSubview:_deleteImageView];
        [_deleteImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(_imageView.mas_top).offset(-3);
            make.right.mas_equalTo(_imageView.mas_right).offset(3);
            make.width.mas_equalTo(@30);
            make.height.mas_equalTo(@30);
        }];
    }
    return self;
}


-(void)clearImage:(UITapGestureRecognizer *)gesture {
    [self.delegate removeImage:gesture];
}
@end
