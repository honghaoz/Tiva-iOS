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

@end
