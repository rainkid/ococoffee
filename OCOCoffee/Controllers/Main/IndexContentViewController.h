//
//  IndexContentViewController.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/6.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IndexContentViewControllerDelegate <NSObject>

-(void)getUserDetailInfo:(NSInteger)uid;

@end

@interface IndexContentViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) id<IndexContentViewControllerDelegate> delegate;
@property(nonatomic,strong) NSMutableArray *dataList;

@end
