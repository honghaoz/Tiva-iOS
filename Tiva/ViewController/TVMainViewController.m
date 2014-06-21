//
//  TVMainViewController.m
//  Tiva
//
//  Created by Zhang Honghao on 6/17/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVMainViewController.h"
#import "TVShowStore.h"
#import "TVShow.h"
#import "iCarousel.h"
#import "UIImageView+AFNetworking.h"
#import <NSString+VTContainsSubstring.h>

#define POSTER_ASPECT_RATIO 680 / 1000
#define EMPTY_POSTER_URL_STRING @"http://slurm.trakt.us/images/poster-dark"

@interface TVMainViewController () <iCarouselDataSource, iCarouselDelegate> {
    iCarousel *_mainCarouselView;
    TVShowStore *_sharedShowStore;
}

@end

@implementation TVMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    LogMethod;
    self.view = [[UIView alloc] init];
    CGRect mainScreen = [UIScreen mainScreen].bounds;
    NSLog(@"%@", NSStringFromCGRect(mainScreen));
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat mainCarouselViewX = 0;
    CGFloat mainCarouselViewY = 0;
    CGFloat mainCarouselViewWidth = mainScreen.size.height;
    CGFloat mainCarouselViewHeight = mainScreen.size.width * 1 / 2;
    CGRect mainCarouselViewRect = CGRectMake(mainCarouselViewX, mainCarouselViewY, mainCarouselViewWidth, mainCarouselViewHeight);
    _mainCarouselView = [[iCarousel alloc] initWithFrame:mainCarouselViewRect];
    [_mainCarouselView setType:iCarouselTypeLinear];
    [_mainCarouselView setDataSource:self];
    [_mainCarouselView setDelegate:self];
    [_mainCarouselView setBounces:NO];
//    [_mainCarouselView setDecelerationRate:0.9];
//    [_mainCarouselView setBounceDistance:0.7];
    [_mainCarouselView setCenterItemWhenSelected:NO];
    [_mainCarouselView setContentOffset:CGSizeMake(- (mainCarouselViewWidth - mainCarouselViewHeight * POSTER_ASPECT_RATIO) / 2, 0)];
    [_mainCarouselView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_mainCarouselView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sharedShowStore = [TVShowStore sharedStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStoreUpdates:) name:@"ShowStoreUpdated" object:_sharedShowStore];
    [_sharedShowStore retrieveShows];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotificationCenter methods

- (void)showStoreUpdates:(NSNotification *)notification {
    NSLog(@"Received ShowStoreUpdated");
//    NSInteger updatedIndex = [[notification userInfo][@"ShowIndex"] integerValue];
    [_mainCarouselView reloadData];
//    [_mainCarouselView reloadItemAtIndex:updatedIndex animated:YES];
}


#pragma mark - iCarousel data source methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    LogMethod;
    return [_sharedShowStore.shows count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    UIImageView *theImageView = (UIImageView *)view;
    
    if (theImageView == nil) {
        theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mainCarouselView.bounds.size.height * POSTER_ASPECT_RATIO, _mainCarouselView.bounds.size.height)];
        [theImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    [theImageView cancelImageRequestOperation];
    NSString *posterURLString = [[_sharedShowStore.shows[index] posterURL] absoluteString];
    if (![posterURLString vt_containsSubstring:EMPTY_POSTER_URL_STRING]) {
        [theImageView setImageWithURL:[_sharedShowStore.shows[index] posterURL]];
    } else {
        [theImageView setImage:[self imageWithRect:theImageView.bounds.size color:[UIColor darkGrayColor]]];
    }
    return theImageView;
}

//- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view {
//    UIImageView *theImageView = (UIImageView *)view;
//    if (theImageView == nil) {
//        theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mainCarouselView.bounds.size.height * POSTER_ASPECT_RATIO, _mainCarouselView.bounds.size.height)];
//        [theImageView setContentMode:UIViewContentModeScaleAspectFill];
//    }
//    [theImageView setImage:[self imageWithRect:theImageView.bounds.size color:[UIColor blueColor]]];
//    return theImageView;
//}

#pragma mark - iCarousel delegate methods

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionVisibleItems) {
        return 10;
    }
    return value;
}

#pragma mark - Helper methods

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
