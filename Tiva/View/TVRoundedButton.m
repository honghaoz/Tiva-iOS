//
//  TVRoundedButton.m
//  Tiva
//
//  Created by Zhang Honghao on 6/23/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVRoundedButton.h"

@implementation TVRoundedButton {
    UIImageView *_hightLightedImageView;
}

- (id)initWithFrame:(CGRect)frame
{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        
////        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
//    }
//    return self;
    return [self initWithFrame:frame borderColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor]];
}

- (instancetype)initWithFrame:(CGRect)frame borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor {
    return [self initWithFrame:frame borderColor:borderColor backgroundColor:backgroundColor radius:5.0];
}

- (instancetype)initWithFrame:(CGRect)frame borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor radius:(CGFloat)radius {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        
        // Set Normal State
        [self setTitleColor:borderColor forState:UIControlStateNormal];
        UIImage *normalImage = [self imageWithRect:frame.size color:[UIColor clearColor]];
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
//        [self setBackgroundImage:[self imageWithRect:frame.size color:borderColor] forState:UIControlStateNormal];
        
//        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
//        [[UIColor whiteColor] getRed:&red green:&green blue:&blue alpha:&alpha];
//        UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:0];
//        [self setBackgroundColor:newColor];
        
        // Set Highlighted State
        [self setTitleColor:backgroundColor forState:UIControlStateHighlighted];
//        _hightLightedImageView = [[UIImageView alloc] initWithImage:[self imageWithRect:frame.size color:borderColor]];
        ;
//        [_hightLightedImageView setAlpha:0];
//        [self addSubview:_hightLightedImageView];
        [self setBackgroundImage:[self imageWithRect:frame.size color:borderColor] forState:UIControlStateHighlighted];
        
//        self.adjustsImageWhenHighlighted = NO;
        
        // Make Sure any subview will not show out of rounder rect
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        self.layer.mask = shape;
        
        // Show a rounded border
        self.layer.borderWidth = 1;
        self.layer.borderColor = [borderColor CGColor];
        self.layer.cornerRadius = radius;
    }
    return self;
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    [self setNeedsDisplay];
//}

//
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    if (self.highlighted == YES) {
//        <#statements#>
//    } else {
//        
//    }
//}

//- (void)setHighlighted:(BOOL)highlighted {
//    // Check if button is going from normal to highlighted
//    if(![self isHighlighted] && highlighted) {
////        [UIView animateWithDuration:1.0f animations:^{
////            [_hightLightedImageView setAlpha:0.4];
////        }];
//        [self setBackgroundColor:[UIColor whiteColor]];
//    }
//    // Check if button is going from highlighted to normal
//    else if([self isHighlighted] && !highlighted) {
//        [UIView animateWithDuration:0.8f animations:^{
////            [_hightLightedImageView setAlpha:0.0];
//            CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
//            [self.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
//            UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:0];
//            [self setBackgroundColor:newColor];
//            
//        }];
//    }
//    [super setHighlighted:highlighted];
//}

- (UIImage *)imageWithRect:(CGSize)size color:(UIColor *)color {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    CGContextFillRect(context, bounds);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
