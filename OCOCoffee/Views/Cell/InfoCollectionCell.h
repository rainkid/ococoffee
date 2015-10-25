//
//  InfoViewCollectionCell.h
//  OCOCoffee
//
//  Created by sam on 15/8/26.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoCollectionCellDelete <NSObject>

-(void)removeImage:(UITapGestureRecognizer *)tap;

@end

@interface InfoCollectionCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic,strong)  UIImageView *deleteImageView;

@property(nonatomic,strong) id<InfoCollectionCellDelete> delegate;

@end
