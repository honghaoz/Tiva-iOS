//
//  TVCalendarShowView.h
//  Tiva
//
//  Created by Zhang Honghao on 6/22/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCalendarShowView : UIView

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, assign) CGFloat *columnWidth;

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSMutableArray *)titles
                  columnWidth:(CGFloat )width;

@end
