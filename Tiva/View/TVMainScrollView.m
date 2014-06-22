//
//  TVMainScrollView.m
//  Tiva
//
//  Created by Zhang Honghao on 6/19/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVMainScrollView.h"

@implementation TVMainScrollView {
    NSMutableArray *_coveredViews;
    NSMutableArray *_contentOffsetCouldMove;
//    CGFloat *_contentOffsetCouldMove;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"-initWithFrame: is not a valid initializer MainScrollView, use initWithFrame: contentViewWithViews: direction: instead"
                                     userInfo:nil];
    }
    return nil;
}

//- (id)initWithFrame:(CGRect)frame contentViewWithViews:(NSArray *)views direction:(ScrollDirection)direction {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setShowsHorizontalScrollIndicator:NO];
//        [self setShowsVerticalScrollIndicator:NO];
//        [self setBounces:NO];
//        [self setOpaque:YES];
//        [self setMultipleTouchEnabled:NO];
//        [self setScrollEnabled:NO];
//        // Send touchBegin imediately
//        [self setDelaysContentTouches:NO];
//        // touchs on subvies shouldn't cancel scrollview
//        [self setCanCancelContentTouches:NO];
//    }
//    _direction = direction;
//    NSInteger viewsCount = [views count];
//    _coveredViews = [[NSMutableArray alloc] init];
////    _contentOffsetCouldMove = [[NSMutableArray alloc] init];
//    if (direction == ScrollHorizontal) {
//        CGFloat maxHeight = 0;
//        CGFloat totalWidth = 0;
//        for (int i = 0; i < viewsCount; i++) {
//            UIView *eachView = views[i];
//            [_coveredViews addObject:eachView];
//            if (i == 0) {
//                [_contentOffsetCouldMove addObject:[NSNumber numberWithFloat:0]];
//            } else {
//                [_contentOffsetCouldMove]
//            }
//            if (views[i]) {
//                <#statements#>
//            }
//        }
//    } else {
//        
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
