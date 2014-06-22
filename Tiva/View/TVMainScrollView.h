//
//  TVMainScrollView.h
//  Tiva
//
//  Created by Zhang Honghao on 6/19/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ScrollHorizontal = 100,
    ScrollVertical
} ScrollDirection;

@interface TVMainScrollView : UIScrollView

@property (nonatomic, assign) ScrollDirection direction;

//- (instancetype)initWithFrame:(CGRect)frame contentViewWithViews:(NSArray *)views direction:(ScrollDirection)direction;
//
//- (void)moveToViewIndex:(NSInteger)index;

@end
