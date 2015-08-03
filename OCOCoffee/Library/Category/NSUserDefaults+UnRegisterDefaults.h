//
//  NSUserDefaults+UnRegisterDefaults.h
//  shoppingmall
//
//  Created by imac on 14/11/22.
//  Copyright (c) 2014年 jinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (UnRegisterDefaults)

- (void)startSpoofingUserAgent:(NSString *)userAgent ;

- (void)stopSpoofingUserAgent;

@end
