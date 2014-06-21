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

@interface TVMainViewController () <iCarouselDataSource> {
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
    CGFloat mainCarouselViewHeight = mainScreen.size.width * 2/3;
    CGRect mainCarouselViewRect = CGRectMake(mainCarouselViewX, mainCarouselViewY, mainCarouselViewWidth, mainCarouselViewHeight);
    _mainCarouselView = [[iCarousel alloc] initWithFrame:mainCarouselViewRect];
    [_mainCarouselView setType:iCarouselTypeLinear];
    [_mainCarouselView setDataSource:self];
    
    [_mainCarouselView setBackgroundColor:[UIColor whiteColor]];
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


#pragma mark - iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    LogMethod;
    return [_sharedShowStore.shows count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
//    LogMethod;
    if (view == nil) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mainCarouselView.bounds.size.height * 680 / 1000, _mainCarouselView.bounds.size.height)];
        [view setImageWithURL:[_sharedShowStore.shows[index] posterURL]];
        [view setContentMode:UIViewContentModeScaleAspectFill];
        return view;
    } else {
        [(UIImageView *)view setImageWithURL:[_sharedShowStore.shows[index] posterURL]];
    }
    
    return view;
}

@end
