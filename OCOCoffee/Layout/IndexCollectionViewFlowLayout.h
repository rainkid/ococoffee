//
//  IndexCollectionViewFlowLayout.m
//  OCOCoffee
//
//  Created by sam on 15/8/21.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//
#import <UIKit/UIKit.h>

@class  IndexCollectionViewFlowLayout;

@protocol IndexCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@required
/**
 *  number of column in section protocol delegate methods
 *
 *  @param collectionView collectionView
 *  @param layout         IndexCollectionViewFlowLayout
 *  @param sectionIndex   section index
 *
 *  @return number of column
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(IndexCollectionViewFlowLayout *)layout
   numberOfColumnsInSection:(NSInteger)section;

@end


@interface IndexCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<IndexCollectionViewDelegateFlowLayout> delegate;

@property (nonatomic) BOOL enableStickyHeaders; //Defalut is NO, set it's YES will sticky the section header.

@end