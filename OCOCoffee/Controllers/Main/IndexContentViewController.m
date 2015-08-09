//
//  IndexContentViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/6.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "IndexContentViewController.h"
#import "IndexViewLayout.h"
#import "IndexCollectionViewCell.h"

@interface IndexContentViewController (){
    
    IndexViewLayout *_indexViewLayout;
}

@end

@implementation IndexContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataList = [[NSMutableArray alloc] initWithCapacity:0];
   // _dataList = [self getTestData];
    
    if(_collectionView == nil){
        // NSLog(@"collection");
        _indexViewLayout = [[IndexViewLayout alloc] init];
        _indexViewLayout.minimumInteritemSpacing = 5.0;
        _indexViewLayout.minimumLineSpacing = 8.0;
        _indexViewLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _indexViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:_indexViewLayout];
        _collectionView.delegate  = self;
        _collectionView.dataSource =self;
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        [_collectionView registerClass:[IndexCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    }
    
    [self.view addSubview:_collectionView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    IndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.userImageView.image = [UIImage imageNamed:@"001.png"];
    return cell;
}


-(NSMutableArray *)getTestData {
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0;i< 5;i++){
        [mutableArr addObject:[UIImage imageNamed:@"001.png"]];
        [mutableArr addObject:[UIImage imageNamed:@"002.png"]];
    }
    return mutableArr;
    
}

@end
