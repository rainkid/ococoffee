//
//  IndexListItem.h
//  OCOCoffee
//
//  Created by sam on 15/8/20.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//
#import "TagItem.h"
#import <Foundation/Foundation.h>

@interface IndexListItem : NSObject

@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSNumber *age;
@property(nonatomic, copy) NSString *range;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, copy) NSString *constellation;
@property(nonatomic, copy) NSString *distance;
@property(nonatomic, copy) NSString *headimgurl;
@property(nonatomic, copy) NSString *last_login_time;
@property(nonatomic, copy) NSString *nickname;

@property(nonatomic, strong) NSMutableArray *TagItems;

+ (instancetype)indexListItemWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
