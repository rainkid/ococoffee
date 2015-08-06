//
//  CenterTableViewCell.m
//  OCOCoffee
//
//  Created by sam on 15/8/5.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "SeparatorView.h"
#import "CenterTableViewCell.h"

@interface CenterTableViewCell()

@end

@implementation CenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        __weak typeof(self) weakSelf = self;
        
        _limageView = [UIImageView new];
        _limageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_limageView];
        [_limageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(47/2);
            make.centerY.equalTo(weakSelf);
        }];
        
        _label = [UILabel new];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf);
            make.left.mas_equalTo(_limageView.mas_right).offset(47/2);
        }];
        
        CGFloat height = 0.5;
        if ([[UIScreen mainScreen] scale] < 2) {
            height = 1;
        }
        
        SeparatorView *sepView = [SeparatorView new];
        [sepView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mas_bottom);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(weakSelf.mas_width);
        }];

    }
    return self;
}

@end
