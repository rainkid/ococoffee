//
//  InviteTableViewCell.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/31.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "InviteTableViewCell.h"
#import <Masonry/Masonry.h>



@implementation InviteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
          __weak typeof(self) weakSelf = self;
        self.typeLabel = ({
            UILabel *label = [UILabel new];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont fontWithName:@"Helvetica" size:16.0];
            label;
        });
        [self.contentView addSubview:self.typeLabel];
         
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(self.mas_left).offset(12);
            make.centerY.mas_equalTo(weakSelf);
           // make.center.mas_equalTo(weakSelf);
            //make.width.equalTo(@60);
        }];

        self.textfield = ({
            UITextField *field = [UITextField new];
            field.textAlignment = NSTextAlignmentLeft;
            field.textColor = [UIColor lightGrayColor];
            field.font = [UIFont fontWithName:@"Helvtica" size:13];
            field;
            
        });
        [self addSubview:self.textfield];
        
        [self.textfield mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(self.typeLabel.mas_right).offset(12);
            make.width.mas_equalTo(@250);
            //make.center.mas_equalTo(weakSelf);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            
        }];
        
        _underLineImageView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView;
        });
        [self addSubview:_underLineImageView];
        
        [_underLineImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(0);
            make.left.mas_equalTo(weakSelf.mas_left).offset(15);
            make.right.mas_equalTo(weakSelf.mas_right).offset(1);
            make.height.mas_equalTo(@1);
        }];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
