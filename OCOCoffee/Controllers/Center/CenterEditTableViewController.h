//
//  CenterEditTableViewController.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/14.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "CenterHeaderCell.h"
#import "InfoCollectionCell.h"

@protocol CenterEditTableViewControllerDelegate <NSObject>

-(void)loadNewDataFromServer;
-(void)removeUserImage;

@end

@interface CenterEditTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,CenterHeaderCellDelegate,InfoCollectionCellDelete>
@property(nonatomic,strong) NSMutableDictionary *userDict;

@property(nonatomic,strong) id<CenterEditTableViewControllerDelegate>delegate;

@end
