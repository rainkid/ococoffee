//
//  ActivityTableViewCell.m
//  OCOCoffee
//
//  Created by sam on 15/8/17.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//
#import "Global.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import "ActivityTableViewCell.h"

static const CGFloat kPhotoHeight = 126/2;

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        __weak typeof(self) weakSelf = self;
        UIFont *font = [UIFont systemFontOfSize:14];
        UIColor *labelTextCollor = [UIColor colorFromHexString:@"#888888"];
        
        //用户图像
        UIImageView *headerImageView = [UIImageView new];
        headerImageView.layer.cornerRadius = (kPhotoHeight) /2;
        headerImageView.layer.masksToBounds = YES;
        headerImageView.userInteractionEnabled = YES;
        self.headerImageView = headerImageView;
        [self addSubview:headerImageView];
        
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(weakSelf).offset(32/2);
            make.width.height.mas_equalTo(kPhotoHeight);
        }];
        
        //状态图片
        UIImageView *statusImageView =[UIImageView new];
        self.statusImageView = statusImageView;
        [self addSubview:statusImageView];
        [statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf);
            make.top.mas_equalTo(weakSelf.mas_top);
        }];
        
        //用户昵称
        UILabel *nicknameLabel = [UILabel new];
        nicknameLabel.font = [UIFont systemFontOfSize:16];
        self.nicknameLabel = nicknameLabel;
        [self addSubview:nicknameLabel];
        [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerImageView.mas_top).offset(22/2);
            make.left.mas_equalTo(headerImageView.mas_right).offset(36/2);
        }];
        
        //年龄
        UILabel *sexAgeLabel = [UILabel new];
        sexAgeLabel.font = font;
        sexAgeLabel.textColor = [UIColor colorFromHexString:@"#f16681"];
        self.sexAgeLabel = sexAgeLabel;
        [self addSubview:sexAgeLabel];
        [sexAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nicknameLabel);
            make.top.mas_equalTo(nicknameLabel.mas_bottom).offset(14/2);
        }];
        
        //星座
        UILabel *conLabel =[UILabel new];
        conLabel.font = font;
        conLabel.textColor = [UIColor colorFromHexString:@"#f16681"];
        self.conLabel = conLabel;
        [self addSubview:conLabel];
        [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sexAgeLabel);
            make.left.mas_equalTo(sexAgeLabel.mas_right).offset(14/2);
        }];
        
        //
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(headerImageView.mas_left);
            make.right.mas_equalTo(weakSelf.mas_right);
            make.top.mas_equalTo(headerImageView.mas_bottom).offset(24/2);
        }];
        
        //地址图片
        UIImageView *addressImageView = [UIImageView new];
        addressImageView.image = [UIImage imageNamed:@"center_address"];
        [self addSubview:addressImageView];
        [addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headerImageView);
            make.width.mas_equalTo(26/2);
            make.top.mas_equalTo(line.mas_bottom).offset(24/2);
        }];
        
        
        //address标签
        UILabel *addressLabel = [UILabel new];
        addressLabel.font = font;
        addressLabel.numberOfLines = 0;
        addressLabel.textColor = labelTextCollor;
        addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.addressLabel = addressLabel;
        [self addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(addressImageView.mas_right).offset(24/2);
            make.right.mas_equalTo(weakSelf);
            make.top.mas_equalTo(addressImageView);
        }];
        
        //timeImgeView
        UIImageView *timeImageView = [UIImageView new];
        timeImageView.image= [UIImage imageNamed:@"center_time"];
        [self addSubview:timeImageView];
        [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headerImageView);
            make.top.mas_equalTo(addressLabel.mas_bottom).offset(24/2);
        }];
        
        UILabel *nearTimeLabel = [UILabel new];
        nearTimeLabel.font = font;
        nearTimeLabel.textColor = labelTextCollor;
        [self addSubview:nearTimeLabel];
        self.nearTimeLabel = nearTimeLabel;
        [nearTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(addressLabel);
            make.top.mas_equalTo(addressLabel.mas_bottom).offset(24/2);
        }];
        
        //descImageView
        UIImageView *descImageView = [UIImageView new];
        descImageView.image= [UIImage imageNamed:@"center_desc"];
        [self addSubview:descImageView];
        [descImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(timeImageView);
            make.top.mas_equalTo(nearTimeLabel.mas_bottom).offset(24/2);
        }];
        
        //descLabel
        UILabel *descLabel = [UILabel new];
        descLabel.font = font;
        descLabel.textColor = labelTextCollor;
        self.descLabel = descLabel;
        [self addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nearTimeLabel);
            make.top.mas_equalTo(nearTimeLabel.mas_bottom).offset(24/2);
        }];
        
        UIView *lineTwo = [UIView new];
        lineTwo.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
        [self addSubview:lineTwo];
        [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.left.mas_equalTo(line);
            make.top.mas_equalTo(descLabel.mas_bottom).offset(24/2);
        }];

        UILabel *beforeLabel = [UILabel new];
        beforeLabel.textColor = labelTextCollor;
        beforeLabel.font = font;
        self.beforeLabel = beforeLabel;
        [self addSubview:beforeLabel];
        [beforeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineTwo.mas_bottom).offset(24/2);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-2);
        }];
    
        UIView *bottom = [UIView new];
        bottom.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
        [self addSubview:bottom];
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(14/2);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
