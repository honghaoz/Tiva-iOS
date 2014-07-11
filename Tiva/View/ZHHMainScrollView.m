//
//  ZHHMainScrollView.m
//  Tiva
//
//  Created by Zhang Honghao on 6/19/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "ZHHMainScrollView.h"

@interface ZHHMainScrollView () <UIScrollViewDelegate>

@end

@implementation ZHHMainScrollView {
    NSMutableArray *_coveredViews;
    NSMutableArray *_contentOffsetCouldMove;
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

- (id)initWithFrame:(CGRect)frame contentViewWithViews:(NSArray *)views direction:(ScrollDirection)direction {
    self = [super initWithFrame:frame];
    if (self) {
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setBounces:NO];
        [self setOpaque:YES];
        [self setMultipleTouchEnabled:NO];
        [self setScrollEnabled:YES];
        // Send touchBegin imediately
        [self setDelaysContentTouches:NO];
        // touchs on subvies shouldn't cancel scrollview
        [self setCanCancelContentTouches:NO];
        [self setDelegate:self];
    }
    _direction = direction;
    NSInteger viewsCount = [views count];
    _coveredViews = [[NSMutableArray alloc] init];
    _contentOffsetCouldMove = [[NSMutableArray alloc] init];
    if (direction == ScrollHorizontal) {
        CGFloat maxHeight = 0;
        CGFloat totalWidth = 0;
        CGFloat lastWidthOffset = 0;
        
        for (int i = 0; i < viewsCount; i++) {
            UIView *eachView = views[i];
            eachView.userInteractionEnabled = YES;
            // Init _coveredViews
            [_coveredViews addObject:eachView];
            // Init _contentOffsetCouldMove
            if (i == 0) {
                [_contentOffsetCouldMove addObject:[NSNumber numberWithFloat:0]];
            } else {
                UIView *lastView = views[i - 1];
                [_contentOffsetCouldMove addObject:[NSNumber numberWithFloat:lastWidthOffset + lastView.bounds.size.width]];
                lastWidthOffset += eachView.bounds.size.width;
            }
            // Add subview
            CGRect rect = eachView.bounds;
            rect.origin.x = [[_contentOffsetCouldMove objectAtIndex:i] floatValue];
            eachView.frame = rect;
            [self addSubview:eachView];
            // Set max height
            if (eachView.bounds.size.height > maxHeight) {
                maxHeight = eachView.bounds.size.height;
            }
            // Set total width
            totalWidth += eachView.bounds.size.width;
        }
        // Set content size;
        [self setContentSize:CGSizeMake(totalWidth, maxHeight)];
        // Rest content inset;
        [self setContentInset:UIEdgeInsetsZero];
    } else {
        // Wait for implementation
    }
    return self;
}
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    else return hitView;
}

- (void)buttonTapped:(id)sender {
//    NSLog(@"adasd");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)moveToViewIndex:(NSInteger)index animated:(BOOL)animated{
    if (_direction == ScrollHorizontal) {
        CGFloat offsetX = [[_contentOffsetCouldMove objectAtIndex:index] floatValue];
        CGPoint contentOffset = self.contentOffset;
        contentOffset.x = offsetX;
        [self setContentOffset:contentOffset animated:animated];
    } else {
        // Wait for implementation
    }
}

#pragma mark - UIScroll View delegate methods

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
////    LogMethod;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
////    LogMethod;
//    // Decelerate end
//}
//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    LogMethod;
//    // Touch end
//    if (_direction == ScrollHorizontal) {
//        CGFloat offsetX = scrollView.contentOffset.x;
//        NSInteger count = [_contentOffsetCouldMove count];
//        for (int i = 0; i < count; i++) {
//            if (i == count - 1) {
//                [self moveToViewIndex:count - 1 animated:YES];
//                return;
//            }
//            CGFloat distanceLeft = offsetX - [_contentOffsetCouldMove[i] floatValue];
//            CGFloat distanceRight = offsetX - [_contentOffsetCouldMove[i + 1] floatValue];
//            NSLog(@"%f, %f", distanceLeft, distanceRight);
//            if (distanceLeft >= 0 && distanceRight < 0) {
//                if (fabsf(distanceLeft)  < fabsf(distanceRight)) {
//                    [self moveToViewIndex:i animated:YES];
//                } else {
//                    [self moveToViewIndex:i + 1 animated:YES];
//                }
//                i++;
//            }
//            else {
//                continue;
//            }
//        }
//    } else {
//        // wait to implementation
//    }
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    LogMethod;
//}

@end
