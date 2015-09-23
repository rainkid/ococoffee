//
//  MessageCell.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//


#import "MessageCell.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>

@implementation MessageCell

static const CGFloat kPhotoHeight = 126/2;
static const CGFloat kCellHeight = 188/2;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        //用户图像
        _headImageView =({
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
        
        
        
        _numLabel = ({
            UILabel *numLael = [UILabel new];
            numLael.layer.cornerRadius = 18/2;
            numLael.layer.masksToBounds = YES;
            numLael.textAlignment = NSTextAlignmentCenter;
            numLael.textColor = [UIColor whiteColor];
            numLael.backgroundColor = [UIColor colorFromHexString:@"#ee524d"];
            numLael;
        });
        
        [self addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(18);
            make.top.mas_equalTo(_headImageView.mas_top);
            make.right.mas_equalTo(_headImageView.mas_right).offset(18/2);
        }];
        
        //用户昵称
        _nicknameLabel = ({
            UILabel *label = [UILabel new];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:16];
            label;
        });
        
        [self addSubview:_nicknameLabel];
        [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImageView.mas_top).offset(16/2);
            make.left.mas_equalTo(_headImageView.mas_right).offset(36/2);
        }];
        
        _timeLabel = ({
            UILabel *timeLabel = [UILabel new];
            timeLabel.backgroundColor = [UIColor clearColor];
            timeLabel.textColor = [UIColor colorFromHexString:@"#888888"];
            timeLabel;
        });
       
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nicknameLabel.mas_top);
            make.right.mas_equalTo(self.mas_right).offset(-8);
        }];
        
        _messageLabel = ({
            UILabel *msgLabel = [UILabel new];
            msgLabel.textColor = [UIColor colorFromHexString:@"#888888"];
            msgLabel.font = [UIFont fontWithName:@"Helvica" size:13.0];
            msgLabel;
        });
    
        [self addSubview:_messageLabel];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nicknameLabel.mas_bottom).offset(28/2);
            make.left.mas_equalTo(_nicknameLabel);
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
