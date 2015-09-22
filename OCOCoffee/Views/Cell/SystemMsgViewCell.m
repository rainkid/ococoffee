//
//  SystemMsgViewCell.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/21.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kHeadImageHeight  40

#import "SystemMsgViewCell.h"
#import <Masonry/Masonry.h>

@implementation SystemMsgViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
 
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        __weak typeof(self) weakSelf = self;
        _cellView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 5;
            view;
        });
        
        [self.contentView addSubview:_cellView];
        
        [_cellView mas_makeConstraints:^(MASConstraintMaker *make){
           
            make.left.mas_equalTo(weakSelf.mas_left).offset(10);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
            make.top.mas_equalTo(weakSelf.mas_top).offset(1);
            make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(0);
        }];
        
        _titleLabel = ({
            UILabel *label = [UILabel new];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
            label;
        });
        
        [_cellView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(_cellView.mas_left).offset(3);
            make.top.mas_equalTo(_cellView.mas_top).offset(5);
            make.width.equalTo(@160);
        }];
        
        UIImageView *arrowImageView = ({
            UIImageView *aImageView = [UIImageView new];
            aImageView.backgroundColor = [UIColor clearColor];
            aImageView.image = [UIImage imageNamed:@"arrow"];
            aImageView;
        });
        
        [_cellView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(weakSelf.cellView.mas_right).offset(-30);
            make.top.mas_equalTo(_cellView.mas_top).offset(8);
            make.height.mas_equalTo(@15);
            make.width.mas_equalTo(@10);
        }];
        
        UIImageView *underLineImageView  = ({
            UIImageView *speratorImageView = [UIImageView new];
            speratorImageView.image = [UIImage imageNamed:@"underline"];
            speratorImageView.backgroundColor = [UIColor clearColor];
            speratorImageView;
        });
        
        [_cellView addSubview:underLineImageView];
        [underLineImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(weakSelf.cellView.mas_left).offset(2);
            make.right.mas_equalTo(weakSelf.cellView.mas_right).offset(2);
            make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(@1);
        }];
        
        _subCellView  = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
        [_cellView addSubview:_subCellView];
        [_subCellView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(weakSelf.cellView.mas_left);
            make.top.mas_equalTo(underLineImageView.mas_bottom).offset(0);
            make.right.mas_equalTo(weakSelf.cellView.mas_right);
            make.bottom.mas_equalTo(weakSelf.cellView.mas_bottom);
            make.height.equalTo(@65);
        }];
        
        _headImageView = ({
            UIImageView *headImageView = [UIImageView new];
            headImageView.backgroundColor = [UIColor clearColor];
            headImageView.layer.cornerRadius = kHeadImageHeight/2;
            headImageView.layer.masksToBounds = YES;
            headImageView;
        });
        
        [_subCellView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(weakSelf.subCellView.mas_left).offset(5);
            make.width.equalTo(@kHeadImageHeight);
            make.height.equalTo(@kHeadImageHeight);
            make.centerY.mas_equalTo(_subCellView.mas_centerY);
        }];
        
        _messageLabel = ({
            UILabel *label = [UILabel new];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 3;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            label;
        });
        [_subCellView addSubview:_messageLabel];
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(8);
            make.top.mas_equalTo(weakSelf.subCellView.mas_top).offset(5);
            make.right.mas_equalTo(weakSelf.subCellView.mas_right).offset(-6);
            make.centerY.mas_equalTo(weakSelf.subCellView.mas_centerY);
        }];
        
    }

    return self;
}


@end
