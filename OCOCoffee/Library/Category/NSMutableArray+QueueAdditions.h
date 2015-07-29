//
//  NSMutableArray+QueueAdditions.h
//  weather
//
//  Created by imac on 13-11-4.
//  Copyright (c) 2013年 Gionee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;

@end
