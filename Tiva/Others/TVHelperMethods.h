//
//  TVHelperMethods.h
//  Tiva
//
//  Created by Zhang Honghao on 6/23/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVHelperMethods : NSObject

+(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;

/**
 *  Get NSDateFormatter for eastern time zone
 *
 *  @return NSDateFormatter object
 */
+ (NSDateFormatter *)estDateFormatter;

/**
 *  Get NSDateFormatter for local time zone
 *
 *  @return NSDateFormatter object
 */
+ (NSDateFormatter *)localDateFormatter;

+ (NSDate *)dateWithOutTime:(NSDate *)date;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
