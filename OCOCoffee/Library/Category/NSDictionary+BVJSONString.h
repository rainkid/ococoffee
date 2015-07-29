//
//  NSDictionary+BVJSONString.h
//  emotion
//
//  Created by imac on 14-4-21.
//  Copyright (c) 2014年 Gionee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BVJSONString)

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;

@end
