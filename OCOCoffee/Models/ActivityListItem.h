//
//  Activity.h
//  OCOCoffee
//
//  Created by sam on 15/8/13.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActivityListItem : NSObject

@property(nonatomic, copy) NSString *activity_id;
@property(nonatomic, copy) NSString *my_nickname;
@property(nonatomic, copy) NSString *to_nickname;
@property(nonatomic, copy) NSString *to_headimgurl;
@property(nonatomic, copy) NSString *to_age;
@property(nonatomic, copy) NSString *to_sex;
@property(nonatomic, copy) NSString *to_job;
@property(nonatomic, copy) NSString *to_constellation;
@property(nonatomic, copy) NSString *dateline;
@property(nonatomic, copy) NSString *fmt_date;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *sub_status;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *distance;
@property(nonatomic, copy) NSString *create_time;
@property(nonatomic, copy) NSString *sex;

+ (instancetype)activityListItemWithDictionary:(NSDictionary *)dictionary;


@end
