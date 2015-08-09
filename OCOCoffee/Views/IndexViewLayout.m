//
//  IndexViewLayout.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "IndexViewLayout.h"

@implementation IndexViewLayout


-(void)prepareLayout
{
    NSLog(@"Prepare Layout");
}

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

@end
