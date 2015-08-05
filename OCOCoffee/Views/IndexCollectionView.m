//
//  IndexCollectionView.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "IndexCollectionView.h"
#import "IndexCollectionViewCell.h"
#include "IndexViewLayout.h"

@implementation IndexCollectionView

-(instancetype)initWithFrame:(CGRect)frame {
    if(self =[super initWithFrame:frame]){
        //if(_collectionView == nil){
            
            IndexViewLayout *indexViewLayout = [[IndexViewLayout alloc] init];
            indexViewLayout.minimumInteritemSpacing = 5.0;
            indexViewLayout.minimumLineSpacing = 8.0;
            indexViewLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
            indexViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
            _colView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:indexViewLayout];
            _colView.delegate  = self;
            _colView.dataSource =self;
            _colView.backgroundColor = [UIColor lightGrayColor];
            [_colView registerClass:[IndexCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
        
            [self addSubview:_colView];
        
       // }
    }
    return self;
}


//-(UICollectionView *)collectionView {
//    if(_collectionView == nil){
//        
//        IndexViewLayout *indexViewLayout = [[IndexViewLayout alloc] init];
//        indexViewLayout.minimumInteritemSpacing = 5.0;
//        indexViewLayout.minimumLineSpacing = 8.0;
//        indexViewLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//        indexViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height) collectionViewLayout:indexViewLayout];
//        _collectionView.delegate  = self;
//        _collectionView.dataSource =self;
//        _collectionView.backgroundColor = [UIColor lightGrayColor];
//        [_collectionView registerClass:[IndexCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
//        
//        
//    }
//    return _collectionView;
//}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [_items count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *identifier = @"indexCellIdentifier";
    IndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    
    cell.userImageView.image = [UIImage imageNamed:[_items objectAtIndex:indexPath.row]];
    
    NSLog(@"%@",cell.userImageView.image);
    
    return cell;
}


@end

