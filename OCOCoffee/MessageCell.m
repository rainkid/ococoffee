//
//  MessageCell.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell



-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        
        //头像
        _photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _photo.userInteractionEnabled = YES;
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        _photo.clipsToBounds = YES;
        [self.contentView addSubview:_photo];
        
        //时间
    
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
