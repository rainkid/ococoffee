//
//  TagItem.m
//  OCOCoffee
//
//  Created by sam on 15/8/20.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "TagItem.h"

@implementation TagItem

+ (instancetype)tagItemWithDictionary:(NSDictionary *)dictionary
{
    TagItem *item = [[TagItem alloc] initWithDictionary:dictionary];
    return item;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        if ([dictionary[@"id"] isKindOfClass:[NSString class]]) {
            self.tagId = dictionary[@"id"];
        }
        if ([dictionary[@"name"] isKindOfClass:[NSString class]]) {
            self.name = dictionary[@"name"];
        }
        if ([dictionary[@"id"] isKindOfClass:[NSString class]]) {
            self.bg_color = dictionary[@"bg_color"];
        }
    }
    return self;
}

@end
