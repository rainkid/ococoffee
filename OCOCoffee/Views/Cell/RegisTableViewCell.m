//
//  RegisTableViewCell.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Golbal.h"
#import "UIColor+colorBuild.h"
#import "RegisTableViewCell.h"

@interface RegisTableViewCell()

@property (nonatomic, strong) SeparatorView *sepView;

@end

@implementation RegisTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        double tableWidth = SCREEN_WIDTH - (kTableLeftSide*2);
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(13, 15.2, 92.6, 18.3)];
        [self addSubview:_label];
        
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(92.6, 15.2, tableWidth - 92.6, 18.3)];
        [self addSubview:_textField];
        
        
        _button =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button setTitle:@"发送验证码" forState:UIControlStateNormal];
        _button.frame = CGRectMake(tableWidth - 92.6, 7.1, 67, 31.3);
        [[_button layer] setBorderWidth:1.0f];
        [[_button layer] setBorderColor:[UIColor colorFromHexString:@"#4a2320"].CGColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_button setTitleColor:[UIColor colorFromHexString:@"#4a2320"] forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor whiteColor];
        _button.layer.cornerRadius = 3;
        _button.layer.masksToBounds = YES;
        [self addSubview:_button];
        
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

- (void)showBottomLine:(BOOL)showLine
{
    if (showLine) {
        _sepView.hidden = NO;
    }else{
        _sepView.hidden = YES;
    }
}

- (void)showCodeButton:(BOOL)showButton
{
    if (showButton) {
        _button.hidden = NO;
    }else{
        _button.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
