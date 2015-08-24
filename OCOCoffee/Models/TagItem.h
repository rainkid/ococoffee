//
//  TagItem.h
//  OCOCoffee
//
//  Created by sam on 15/8/20.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagItem : NSObject

@property(nonatomic, copy) NSString *tagId;
@property(nonatomic, copy) NSString *bg_color;
@property(nonatomic, copy) NSString *name;

+ (instancetype)tagItemWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
