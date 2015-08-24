//
//  IndexCollectionView.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong,nonatomic) NSMutableArray *items;
@property(strong,nonatomic) UICollectionView *colView;
@property(strong,nonatomic) UICollectionView *collectionView;

@end
