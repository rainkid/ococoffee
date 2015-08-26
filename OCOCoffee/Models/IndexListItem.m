//
//  IndexListItem.m
//  OCOCoffee
//
//  Created by sam on 15/8/20.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "IndexListItem.h"

@implementation IndexListItem

+ (instancetype)indexListItemWithDictionary:(NSDictionary *)dictionary
{
    IndexListItem *item = [[IndexListItem alloc] initWithDictionary:dictionary];
    return item;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        if ([dictionary[@"id"] isKindOfClass:[NSString class]]) {
            self.userId = dictionary[@"id"];
        }
        if ([dictionary[@"age"] isKindOfClass:[NSNumber class]]) {
            self.age = dictionary[@"age"];
        }
        if ([dictionary[@"constellation"] isKindOfClass:[NSString class]]) {
            self.constellation = dictionary[@"constellation"];
        }
        if ([dictionary[@"distance"] isKindOfClass:[NSString class]]) {
            self.distance = dictionary[@"distance"];
        }
        if ([dictionary[@"headimgurl"] isKindOfClass:[NSString class]]) {
            self.headimgurl = dictionary[@"headimgurl"];
        }
        if ([dictionary[@"last_login_time"] isKindOfClass:[NSString class]]) {
            self.last_login_time = dictionary[@"last_login_time"];
        }
        if ([dictionary[@"nickname"] isKindOfClass:[NSString class]]) {
            self.nickname = dictionary[@"nickname"];
        }
        if ([dictionary[@"range"] isKindOfClass:[NSString class]]) {
            self.range = dictionary[@"range"];
        }
        if ([dictionary[@"sex"] isKindOfClass:[NSString class]]) {
            self.range = dictionary[@"sex"];
        }
        
        NSMutableArray *tagArray = [NSMutableArray array];
        if ([dictionary[@"tags"] isKindOfClass:[NSArray class]]) {
            NSArray *tagDicts = dictionary[@"tags"];
            for (NSDictionary *dict in tagDicts) {
                TagItem *item = [TagItem tagItemWithDictionary:dict];
                [tagArray addObject:item];
            }
        }
        self.TagItems = tagArray;

    }
    return self;
}

@end
