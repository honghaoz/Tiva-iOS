//
//  TVHelperMethods.m
//  Tiva
//
//  Created by Zhang Honghao on 6/23/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVHelperMethods.h"

@implementation TVHelperMethods

+(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds  byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    //    shape.strokeColor = [[UIColor grayColor] CGColor];
    view.layer.mask = shape;
    
    view.layer.cornerRadius = radius;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    view.layer.borderWidth = 1;
}

+ (NSDateFormatter *)estDateFormatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // set the locale to fix the formate to read and write;
    //    NSLocale *enUSPOSIXLocale= [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    //    [dateFormatter setLocale:enUSPOSIXLocale];
    // set timezone to EST
    // Note: timeZoneWithAbbreviation is different with timeZoneWithName
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    
    return dateFormatter;
}

+ (NSDateFormatter *)localDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    NSLocale *enUSPOSIXLocale= [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    //    [dateFormatter setLocale:enUSPOSIXLocale];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    
    return dateFormatter;
}

+ (NSDate *)dateWithOutTime:(NSDate *)date {
    NSDateFormatter *formater = [self localDateFormatter];
    [formater setDateFormat:@"dd-MM-yyyy"];
    NSDate *onlyDay = [formater dateFromString:[formater stringFromDate:date]];
    return onlyDay;
}

@end
