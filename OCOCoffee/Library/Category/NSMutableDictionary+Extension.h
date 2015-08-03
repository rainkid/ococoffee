//
//  NSMutableDictionary+Extension.h
//  GMAT
//
//  Created by visitor on 12-6-2.
//  Copyright (c) 2012年 w.sharewithu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Extension)
- (bool) existsValue:(NSString*)expectedValue forKey:(NSString*)key;
- (NSInteger) integerValueForKey:(NSString*)key defaultValue:(NSInteger)defaultValue withRange:(NSRange)range;
- (BOOL) typeValueForKey:(NSString *)key isArray:(BOOL*)bArray isNull:(BOOL*)bNull isNumber:(BOOL*) bNumber isString:(BOOL*)bString;
- (BOOL) valueForKeyIsArray:(NSString *)key;
- (BOOL) valueForKeyIsNull:(NSString *)key;
- (BOOL) valueForKeyIsString:(NSString *)key;
- (BOOL) valueForKeyIsNumber:(NSString *)key;
@end
