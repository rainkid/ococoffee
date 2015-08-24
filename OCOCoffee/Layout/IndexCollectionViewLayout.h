//
//  CustomCollectionViewLayout.h
//  OCOCoffee
//
//  Created by sam on 15/8/21.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexCollectionViewLayout;

@protocol IndexCollectionViewLayoutDelegate <NSObject>
@required
- (CGFloat) collectionView:(UICollectionView*) collectionView
                    layout:(CustomCollectionViewLayout*) layout
  heightForItemAtIndexPath:(NSIndexPath*) indexPath;
@end

@interface IndexCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) CGFloat interItemSpacing;
@property (weak, nonatomic)  id<IndexCollectionViewLayoutDelegate> delegate;

@end
