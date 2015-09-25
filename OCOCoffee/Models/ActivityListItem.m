//
//  Activity.m
//  OCOCoffee
//
//  Created by sam on 15/8/13.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "ActivityListItem.h"

@implementation ActivityListItem

+ (instancetype)activityListItemWithDictionary:(NSDictionary *)dictionary
{
    ActivityListItem *item = [[ActivityListItem alloc] initWithDictionary:dictionary];
    return item;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        if ([dictionary[@"id"] isKindOfClass:[NSString class]]) {
            self.activity_id = dictionary[@"id"];
        }
        if ([dictionary[@"to_nickname"] isKindOfClass:[NSString class]]) {
            self.to_nickname = dictionary[@"to_nickname"];
        }
        if ([dictionary[@"to_headimgurl"] isKindOfClass:[NSString class]]) {
            self.to_headimgurl = dictionary[@"to_headimgurl"];
        }
        if ([dictionary[@"to_constellation"] isKindOfClass:[NSString class]]) {
            self.to_constellation = dictionary[@"to_constellation"];
        }
        if ([dictionary[@"to_age"] isKindOfClass:[NSNumber class]]) {
            self.to_age = dictionary[@"to_age"];
        }
        if ([dictionary[@"to_sex"] isKindOfClass:[NSString class]]) {
            self.to_sex = dictionary[@"to_sex"];
        }
        if ([dictionary[@"to_job"] isKindOfClass:[NSString class]]) {
            self.to_job = dictionary[@"to_job"];
        }
        if ([dictionary[@"dateline"] isKindOfClass:[NSString class]]) {
            self.dateline = dictionary[@"dateline"];
        }
        if ([dictionary[@"fmt_date"] isKindOfClass:[NSString class]]) {
            self.fmt_date = dictionary[@"fmt_date"];
        }
        if ([dictionary[@"address"] isKindOfClass:[NSString class]]) {
            self.address = dictionary[@"address"];
        }
        if ([dictionary[@"status"] isKindOfClass:[NSString class]]) {
            self.status = dictionary[@"status"];
        }
        if ([dictionary[@"sub_status"] isKindOfClass:[NSString class]]) {
            self.sub_status = dictionary[@"sub_status"];
        }
        if ([dictionary[@"description"] isKindOfClass:[NSString class]]) {
            self.desc = dictionary[@"description"];
        }
        if ([dictionary[@"distance"] isKindOfClass:[NSString class]]) {
            self.distance = dictionary[@"distance"];
        }
        if ([dictionary[@"create_time"] isKindOfClass:[NSString class]]) {
            self.create_time = dictionary[@"create_time"];
        }
        if ([dictionary[@"sex"] isKindOfClass:[NSString class]]) {
            self.sex = dictionary[@"sex"];
        }
    }
    return self;
}
@end
