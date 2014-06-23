//
//  TVMainViewController.m
//  Tiva
//
//  Created by Zhang Honghao on 6/17/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVMainViewController.h"
#import "UIImageView+AFNetworking.h"
#import <NSString+VTContainsSubstring.h>
#import <SAMCategories.h>
#import <QuartzCore/QuartzCore.h>

#import "TVShowStore.h"
#import "TVShow.h"
#import "iCarousel.h"
#import "TVAPIClient.h"
#import "TVTraktUser.h"
#import "TVShowDetailsViewController.h"
#import "TVCalendarViewController.h"
#import "TVCalendarShowView.h"
#import "TVRoundedButton.h"
#import "TVHelperMethods.h"

#define POSTER_ASPECT_RATIO (680 / 1000.0)
#define EMPTY_POSTER_URL_STRING @"http://slurm.trakt.us/images/poster-dark"
#define BANNER_ASPECT_RATIO (758 / 140.0)
#define EMPTY_BANNER_URL_STRING @"http://slurm.trakt.us/images/banner"

@interface TVMainViewController () <iCarouselDataSource, iCarouselDelegate, UITableViewDataSource, UITableViewDelegate> {
    CGRect _mainScreen;
    TVShowStore *_sharedShowStore;
    
    UIView *_carouselParentView;
    iCarousel *_carouselView;
    
    TVRoundedButton *_menuButton;
    
    UIView *_todayParentView;
    UILabel *_todayLabel;
    TVRoundedButton *_calendarButton;
    UITableView *_todayTableView;
    
    UIView *_recommendationParentView;
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
    _mainScreen = [UIScreen mainScreen].bounds;
    Swap(&_mainScreen.size.height, &_mainScreen.size.width);
    self.view.backgroundColor = [UIColor blackColor];
    
    // Menu button
    CGFloat menuButtonX = 20;
    CGFloat menuButtonY = 20 + 10 ;
    CGFloat menuButtonWdith = 60;
    CGFloat menuButtonHeight = 40;
    CGRect menuButtonFrame = CGRectMake(menuButtonX, menuButtonY, menuButtonWdith, menuButtonHeight);
    _menuButton = [[TVRoundedButton alloc] initWithFrame:menuButtonFrame];
    [_menuButton setBackgroundColor:[UIColor blackColor]];
    [_menuButton setTitle:@"Menu" forState:UIControlStateNormal];
    [_menuButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
//    [_menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Carousel parent view
    CGFloat carouselParentViewX = GAP_WIDTH;
    CGFloat carouselParentViewY = 20.0;
    CGFloat carouselParentViewWidth = _mainScreen.size.width - 2 * GAP_WIDTH;
    CGFloat carouselParentViewHeight = _mainScreen.size.height * 0.45;
    CGRect carouselParentViewFrame = CGRectMake(carouselParentViewX, carouselParentViewY, carouselParentViewWidth, carouselParentViewHeight);
    _carouselParentView = [[UIView alloc] initWithFrame:carouselParentViewFrame];
    [TVHelperMethods setMaskTo:_carouselParentView byRoundingCorners:UIRectCornerAllCorners withRadius:5.0];
//    _carouselParentView.layer.cornerRadius = 5.0;
//    _carouselParentView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    _carouselParentView.layer.borderWidth = 1;
    
    // Carousel View
    CGFloat carouselViewX = 0;
    CGFloat carouselViewY = 0;
    CGFloat carouselViewWidth = carouselParentViewWidth;
    CGFloat carouselViewHeight = carouselParentViewHeight;
    CGRect carouselViewFrame = CGRectMake(carouselViewX, carouselViewY, carouselViewWidth, carouselViewHeight);
    _carouselView = [[iCarousel alloc] initWithFrame:carouselViewFrame];
    [_carouselView setType:iCarouselTypeLinear];
    [_carouselView setDataSource:self];
    [_carouselView setDelegate:self];
    [_carouselView setBounces:NO];
//    [_carouselParentView setDecelerationRate:0.9];
//    [_carouselParentView setBounceDistance:0.7];
    [_carouselView setCenterItemWhenSelected:NO];
    [_carouselView setContentOffset:CGSizeMake(- (carouselParentViewWidth - carouselParentViewHeight * POSTER_ASPECT_RATIO) / 2, 0)];
    [_carouselView setBackgroundColor:[UIColor clearColor]];
//    _carouselView.layer.cornerRadius = 5;
    [_carouselParentView addSubview:_carouselView];
    
    // Today parent View
    CGFloat todayViewX = carouselParentViewX;
    CGFloat todayViewY = carouselParentViewY + carouselParentViewHeight + GAP_WIDTH;
    CGFloat todayViewWidth = (_mainScreen.size.width - GAP_WIDTH * 2) * 1/3;
    CGFloat todayViewHeight = _mainScreen.size.height - (carouselParentViewY +  carouselParentViewHeight) - 2 * GAP_WIDTH;
    CGRect todayViewFrame = CGRectMake(todayViewX, todayViewY, todayViewWidth, todayViewHeight);
    _todayParentView = [[UIView alloc] initWithFrame:todayViewFrame];
    [TVHelperMethods setMaskTo:_todayParentView byRoundingCorners:UIRectCornerAllCorners withRadius:5.0];
//    _todayParentView.layer.cornerRadius = 5.0;
//    _todayParentView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    _todayParentView.layer.borderWidth = 1;
    
    // Today label view
    CGFloat todayLabelX = 0;
    CGFloat todayLabelY = 0;
    CGFloat todayLabelWidth = todayViewWidth;
    CGFloat todayLabelHeight = 44;
    CGRect todayLabelFrame = CGRectMake(todayLabelX, todayLabelY, todayLabelWidth, todayLabelHeight);
    _todayLabel = [[UILabel alloc] initWithFrame:todayLabelFrame];
    [_todayLabel setText:@"Today"];
    [_todayLabel setTextAlignment:NSTextAlignmentCenter];
    [_todayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21]];
    [_todayLabel setBackgroundColor:LABEL_COLOR];
    [_todayLabel setTextColor:FONT_COLOR];
    [_todayParentView addSubview:_todayLabel];
    
    // Calendar button
    CGFloat calendarButtonWidth = 85;
    CGFloat calendarButtonHeight = 30;
    CGFloat calendarButtonY = (todayLabelHeight - calendarButtonHeight) / 2;
    CGFloat calendarButtonX = todayViewWidth - calendarButtonWidth - calendarButtonY;
    CGRect calendarButtonFrame = CGRectMake(calendarButtonX, calendarButtonY, calendarButtonWidth, calendarButtonHeight);
    _calendarButton = [[TVRoundedButton alloc] initWithFrame:calendarButtonFrame];
    [_calendarButton setBackgroundColor:[UIColor clearColor]];
    [_calendarButton setTitle:@"Calendar" forState:UIControlStateNormal];
//    [_calendarButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
//    [_calendarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_calendarButton addTarget:self action:@selector(calendarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_todayParentView addSubview:_calendarButton];
    
    // Today table view
    CGFloat todayTableViewX = todayLabelX;
    CGFloat todayTableViewY = todayLabelHeight;
    CGFloat todayTableViewWidth = todayViewWidth;
    CGFloat todayTableViewHeight = todayViewHeight - todayLabelHeight;
    CGRect todayTableViewFrame = CGRectMake(todayTableViewX, todayTableViewY, todayTableViewWidth, todayTableViewHeight);
    _todayTableView = [[UITableView alloc] initWithFrame:todayTableViewFrame];
    _todayTableView.dataSource = self;
    _todayTableView.delegate = self;
    [_todayTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_todayParentView addSubview:_todayTableView];
    
    [self.view addSubview:_carouselParentView];
    [self.view addSubview:_menuButton];
    [self.view addSubview:_todayParentView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sharedShowStore = [TVShowStore sharedStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStoreUpdates:) name:@"ShowStoreUpdated" object:_sharedShowStore];
    [_sharedShowStore retrieveShows];
    
    [[TVTraktUser sharedUser] setUsername:@"honghaoz" andPassword:@"Zhh358279765099"];
    [[TVAPIClient sharedClient] testUsername:[TVTraktUser sharedUser].username passwordSha1:[TVTraktUser sharedUser].passwordSha1 success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failure: %@", error);
    }];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 

- (void)menuButtonTapped:(id)sender {
    LogMethod;
}

- (void)calendarButtonTapped:(id)sender {
    LogMethod;
    [_sharedShowStore processEpisodesDictionary];
    TVCalendarViewController *calendarVC = [[TVCalendarViewController alloc] init];
//    UINavigationController *newNavigationVC = [[UINavigationController alloc] initWithRootViewController:calendarVC];
//    [newNavigationVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [newNavigationVC setModalPresentationStyle:UIModalPresentationFullScreen];
    [calendarVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [calendarVC setModalPresentationStyle:UIModalPresentationFullScreen];
    [calendarVC.view setBounds:CGRectMake(GAP_WIDTH, 20, _mainScreen.size.width - 2 * GAP_WIDTH, _mainScreen.size.height - GAP_WIDTH - 20)];
    [self presentViewController:calendarVC animated:YES completion:nil];
}

#pragma mark - NSNotificationCenter methods

- (void)showStoreUpdates:(NSNotification *)notification {
//    NSLog(@"Received ShowStoreUpdated");
//    NSInteger updatedIndex = [[notification userInfo][@"ShowIndex"] integerValue];
    [_carouselView reloadData];
//    [_mainCarouselView reloadItemAtIndex:updatedIndex animated:YES];
    [_todayTableView reloadData];
}


#pragma mark - iCarousel data source methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_sharedShowStore.shows count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    UIImageView *theImageView = (UIImageView *)view;
    
    if (theImageView == nil) {
        theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _carouselView.bounds.size.height * POSTER_ASPECT_RATIO, _carouselView.bounds.size.height)];
        [theImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    [theImageView cancelImageRequestOperation];
    NSString *posterURLString = [[_sharedShowStore.shows[index] posterURL] absoluteString];
    if (![posterURLString vt_containsSubstring:EMPTY_POSTER_URL_STRING]) {
        if ([[UIScreen mainScreen] sam_isRetina]) {
            posterURLString = [posterURLString stringByReplacingOccurrencesOfString:@".jpg" withString:@"-300.jpg"];
        } else {
            posterURLString = [posterURLString stringByReplacingOccurrencesOfString:@".jpg" withString:@"-138.jpg"];
        }
        [theImageView setImageWithURL:[NSURL URLWithString:posterURLString]];
    } else {
        [theImageView setImage:[self imageWithRect:theImageView.bounds.size color:[UIColor darkGrayColor]]];
    }
    return theImageView;
}

#pragma mark - iCarousel delegate methods

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionVisibleItems) {
        return 10;
    }
    return value;
}

#pragma mark - Today table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sharedShowStore.shows count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *bannerImageView = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayShow"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TodayShow"];
        CGRect bannerRect = CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.width / BANNER_ASPECT_RATIO);
        bannerImageView = [[UIImageView alloc] initWithFrame:bannerRect];
        [bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:bannerImageView];
    }
    for (UIView *subView in cell.contentView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            bannerImageView =  (UIImageView *)subView;
        }
    }
    [bannerImageView cancelImageRequestOperation];
    [bannerImageView setImage:[self imageWithRect:bannerImageView.bounds.size color:[UIColor lightGrayColor]]];
    NSString *bannerURLString = [[_sharedShowStore.shows[indexPath.row] bannerURL] absoluteString];
    if (![bannerURLString vt_containsSubstring:EMPTY_BANNER_URL_STRING]) {
//        [bannerImageView setImage:[self imageWithRect:bannerImageView.bounds.size color:[UIColor lightGrayColor]]];
    } else {
        [bannerImageView setImageWithURL:[_sharedShowStore.shows[indexPath.row] bannerURL]];
    }
    
    return cell;
}

#pragma mark - Today table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.width / BANNER_ASPECT_RATIO;
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
