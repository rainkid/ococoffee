//
//  LoginTableViewCell.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//
#import "Golbal.h"
#import "LoginTableViewCell.h"
#import "LoginViewController.h"

@interface LoginTableViewCell()

@property (nonatomic, strong) SeparatorView *sepView;

@end

@implementation LoginTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(27.2, 46.9, 28, 38)];
        [self addSubview:imageView];
        
        double tableWidth = SCREEN_WIDTH - (kTableLeftSide*2);
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(56.6, 0, tableWidth - 60, self.frame.size.height)];
        [self addSubview:_textField];
        
        CGFloat height = 0.5;
        if ([[UIScreen mainScreen] scale] < 2) {
            height = 1;
        }
        
        _sepView = [[SeparatorView alloc] initWithFrame:CGRectMake(0, 47 - height, tableWidth, height)];
        [_sepView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.sepView];
    }
    return self;
}

- (void)setBottomLine:(BOOL)bottomLine{
    if (bottomLine) {
        _sepView.hidden = NO;
    }else{
        _sepView.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
