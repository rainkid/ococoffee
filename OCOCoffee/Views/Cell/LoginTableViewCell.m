//
//  LoginTableViewCell.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//
#import "Global.h"
#import <Masonry/Masonry.h>
#import "LoginTableViewCell.h"
#import "LoginViewController.h"

@interface LoginTableViewCell()<UITextFieldDelegate>

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
        __weak typeof(self) weakSelf = self;

        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
        }];
        
        _textField = [UITextField new];
        _textField.userInteractionEnabled = YES;
        _textField.delegate = self;
        [_textField setReturnKeyType:UIReturnKeyDone];
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(weakSelf.mas_height);
            make.left.mas_equalTo(weakSelf).offset(42);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
            make.centerY.equalTo(weakSelf);
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


#pragma mark-textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"textFieldShouldReturn %ld", textField.tag);
    return NO;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing %ld", textField.tag);
    
    [textField becomeFirstResponder];
}

-(void) textFieldDidEndEditing: (UITextField * ) textField {
    NSLog(@"textFieldDidEndEditing %ld", textField.tag);
    NSLog(@"controller %ld", textField.tag);
}
@end
