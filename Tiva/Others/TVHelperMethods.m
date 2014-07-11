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


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)printDateInLocalTime:(NSDate *)date {
    NSDateFormatter *formatter = [self localDateFormatter];
    [formatter setDateFormat:@"hh:mm aa dd-MM-yyyy"];
    NSLog([formatter stringFromDate:date]);
}

+ (NSMutableArray *)dateKeysForDay:(NSDate *)date numberOfDaysBefore:(NSInteger)daysBefore numberOfDaysAfter:(NSInteger)daysAfter {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    for (int i = daysBefore; i > 0; i--) {
        NSDate *theDay = [[NSDate date] dateByAddingTimeInterval:-(60 * 60 * 24) * i];
        [keys addObject:[TVHelperMethods dateWithOutTime:theDay]];
    }
    [keys addObject:[TVHelperMethods dateWithOutTime:[NSDate date]]];
    for (int i = 1; i <= daysAfter; i++) {
        NSDate *theDay = [[NSDate date] dateByAddingTimeInterval:(60 * 60 * 24) * i];
        [keys addObject:[TVHelperMethods dateWithOutTime:theDay]];
    }
    return keys;
}

@end
