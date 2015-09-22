//
//  FriendListViewCell.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/22.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kPhotoHeight 63

#import "FriendListViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+colorBuild.h"

@implementation FriendListViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
      //  __weak typeof weakSelf = self;
        
        //用户图像
        _headImageView = ({
            UIImageView *headerImageView = [UIImageView new];
            headerImageView.layer.cornerRadius = (kPhotoHeight) /2;
            headerImageView.layer.masksToBounds = YES;
            headerImageView.userInteractionEnabled = YES;
            headerImageView;
        });
        
        [self addSubview:_headImageView];
        
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self).offset(26/2);
            make.width.height.mas_equalTo(kPhotoHeight);
        }];
        
        //用户昵称
        
        _nameLabel = ({
            UILabel *nicknameLabel = [UILabel new];
            nicknameLabel.font = [UIFont systemFontOfSize:16];
            nicknameLabel.backgroundColor = [UIColor clearColor];
            nicknameLabel;
        });
  
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImageView.mas_top).offset(10/2);
            make.left.mas_equalTo(_headImageView.mas_right).offset(36/2);
        }];
        
        //用户性别,星座
        UIView *firstView = [UIView new];
        firstView.backgroundColor = [UIColor redColor];
        [self addSubview:firstView];
        [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(8/2);
            make.height.left.mas_equalTo(_nameLabel);
        }];
        
        _sexImageView = ({
            UIImageView *sexImageView = [UIImageView new];
            sexImageView.backgroundColor= [UIColor clearColor];
            sexImageView;
        });
       
        [firstView addSubview:_sexImageView];
        [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(firstView);
            make.left.mas_equalTo(firstView);
            make.width.equalTo(@8);
            make.height.equalTo(@11);
        }];
        
        _ageLabel = ({
            UILabel *ageLabel = [UILabel new];
            ageLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            ageLabel.textColor = [UIColor colorFromHexString:@"#f16681"];
            ageLabel;

        });
        [firstView addSubview:_ageLabel];
        [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(firstView);
            make.left.mas_equalTo(_sexImageView.mas_right).offset(16/2);
        }];
        
        UILabel *sepLine =({
            UILabel *label = [UILabel new];
            label.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
            label;
        });
        
        [firstView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(_ageLabel.mas_right).offset(10);
            make.top.mas_equalTo(_ageLabel.mas_top);
            make.width.equalTo(@1);
            make.height.mas_equalTo(_ageLabel.mas_height);
        }];
        
        _constellationLabel = ({
            UILabel *conLabel =[UILabel new];
            conLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            conLabel.textColor = [UIColor colorFromHexString:@"#f16681"];
            conLabel;
        });
        [firstView addSubview:_constellationLabel];
        [_constellationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(firstView);
            make.left.mas_equalTo(sepLine.mas_right).offset(20/2);
        }];
        
        _messageLabel = ({
            UILabel *lastLabel = [UILabel new];
            lastLabel.textColor = [UIColor colorFromHexString:@"#888888"];
            lastLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
            lastLabel;
        });
      
        [self addSubview:_messageLabel];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(firstView.mas_bottom).offset(8/2);
            make.left.mas_equalTo(firstView);
        }];
        
        //
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(_messageLabel.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(_messageLabel.mas_bottom).offset(26/2);
        }];
    }
    return self;
}
@end
