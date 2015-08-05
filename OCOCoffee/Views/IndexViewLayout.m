//
//  IndexViewLayout.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "IndexViewLayout.h"

@implementation IndexViewLayout



//UICollectionViewLayout 必须实现的三个方法

-(CGSize)collectionViewContentSize {
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if(numberOfSections == 0){
        return CGSizeZero;
    }
    CGSize contentSize = self.collectionView.bounds.size;
    return contentSize;
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *arr ;
    return arr;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


-(void)prepareLayout
{
    NSLog(@"Prepare Layout!");
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.collectionView.bounds.size.width -15)/2, 120);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0f;
}


@end
