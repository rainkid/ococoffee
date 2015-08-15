//
//  Activity.h
//  OCOCoffee
//
//  Created by sam on 15/8/13.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SexMale = 1,
    SexFemale
} Sex;

@interface ActivityModel : NSObject

@property(nonatomic, assign) unsigned int id;
@property(nonatomic, assign) NSString *nickname;
@property(nonatomic, copy) NSString *headImage;
@property(nonatomic, assign) unsigned int age;
@property(nonatomic, assign) NSString *constellation;
@property(nonatomic, assign) Sex sex;
@property(nonatomic, assign) NSDictionary *labels;
@property(nonatomic, assign) NSDictionary *imags;
@property(nonatomic, assign) NSString *userLastAddress;
@property(nonatomic, assign) NSString *userDistance;
@property(nonatomic, assign) NSString *userLastTime;
@property(nonatomic, assign) NSString *dateline;
@property(nonatomic, assign) NSString *address;
@property(nonatomic, assign) NSString *desc;
@property(nonatomic, assign) NSString *distance;
@property(nonatomic, assign) unsigned int status;

@end
