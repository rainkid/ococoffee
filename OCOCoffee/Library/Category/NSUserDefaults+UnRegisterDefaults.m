//
//  NSUserDefaults+UnRegisterDefaults.m
//  shoppingmall
//
//  Created by imac on 14/11/22.
//  Copyright (c) 2014年 jinli. All rights reserved.
//

#import "NSUserDefaults+UnRegisterDefaults.h"

#define kWebViewUserAgentKey @"UserAgent"

@implementation NSUserDefaults (UnRegisterDefaults)

- (void)startSpoofingUserAgent:(NSString *)userAgent {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ kWebViewUserAgentKey : userAgent }];
}

- (void)stopSpoofingUserAgent {
    [[NSUserDefaults standardUserDefaults] unregisterDefaultForKey:kWebViewUserAgentKey];
}

- (void)unregisterDefaultForKey:(NSString *)defaultName {
    NSDictionary *registeredDefaults = [[NSUserDefaults standardUserDefaults] volatileDomainForName:NSRegistrationDomain];
    if ([registeredDefaults objectForKey:defaultName] != nil) {
        NSMutableDictionary *mutableCopy = [NSMutableDictionary dictionaryWithDictionary:registeredDefaults];
        [mutableCopy removeObjectForKey:defaultName];
        [self replaceRegisteredDefaults:[mutableCopy copy]];
    }
}

- (void)replaceRegisteredDefaults:(NSDictionary *)dictionary {
    [[NSUserDefaults standardUserDefaults] setVolatileDomain:dictionary forName:NSRegistrationDomain];
}


@end
