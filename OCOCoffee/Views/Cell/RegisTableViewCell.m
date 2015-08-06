//
//  RegisTableViewCell.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Golbal.h"
#import <Masonry/Masonry.h>
#import "UIColor+colorBuild.h"
#import <ActionSheetStringPicker.h>
#import "RegisTableViewCell.h"


@interface RegisTableViewCell()

@property (nonatomic, strong) SeparatorView *sepView;
@property (nonatomic, strong) UIPickerView *tradePickerView;

@end

@implementation RegisTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        __weak typeof(self) weakSelf = self;

        _label = [UILabel new];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(18);
            make.centerY.mas_equalTo(weakSelf);
        }];
        
        
        _textField = [UITextField new];
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_label.mas_right).offset(17);
            make.centerY.mas_equalTo(weakSelf);
        }];
        
        _button =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button setTitle:@"发送验证码" forState:UIControlStateNormal];
        [[_button layer] setBorderWidth:1.0f];
        [[_button layer] setBorderColor:[UIColor colorFromHexString:@"#4a2320"].CGColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_button setTitleColor:[UIColor colorFromHexString:@"#4a2320"] forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor whiteColor];
        _button.layer.cornerRadius = 3;
        _button.layer.masksToBounds = YES;
        [self addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf).offset(-4);
            make.centerY.mas_equalTo(weakSelf);
        }];
        
        CGFloat height = 0.5;
        if ([[UIScreen mainScreen] scale] < 2) {
            height = 1;
        }
        
        _sepView = [SeparatorView new];
        [_sepView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.sepView];
        [_sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mas_bottom);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(weakSelf.mas_width);
        }];
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
