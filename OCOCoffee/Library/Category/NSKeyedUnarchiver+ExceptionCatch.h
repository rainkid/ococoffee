//
//  NSKeyedUnarchiver+ExceptionCatch.h
//  RRSpring
//
//  Created by jerrykrinock on 9/28/12.
//  Copyright (c) 2012 github.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSKeyedUnarchiver (CatchExceptions)

/*!
 @brief    Like unarchiveObjectWithData:, except it returns the
 exception by reference.
 
 
 @param    exception_p  Pointer which will, upon return, if an
 exception occurred and said pointer is not NULL, point to said
 NSException.
 */
+ (id)unarchiveObjectWithData:(NSData*)data
                  exception_p:(NSException**)exception_p ;

+ (id)unarchiveObjectWithFile:(NSString *)path
                  exception_p:(NSException**)exception_p;

@end
