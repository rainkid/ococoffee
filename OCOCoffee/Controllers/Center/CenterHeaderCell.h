//
//  CenterHeaderCell.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/14.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CenterHeaderCellDelegate <NSObject>

-(void)changeHeadImage:(UITapGestureRecognizer *)tap;
-(void)savePhoto:(UIButton *)button;



@end

@interface CenterHeaderCell : UITableViewCell

@property(nonatomic,strong) UICollectionView *imgCollectionView;
@property(nonatomic,strong) NSString *headImgURLString;
@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UIView *imgListView;

@property(nonatomic,strong) id<CenterHeaderCellDelegate>delegate;
@end
