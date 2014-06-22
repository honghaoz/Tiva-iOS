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

#import "TVShowStore.h"
#import "TVShow.h"
#import "iCarousel.h"
#import "TVAPIClient.h"
#import "TVTraktUser.h"
#import "TVShowDetailsViewController.h"

#define POSTER_ASPECT_RATIO (680 / 1000.0)
#define EMPTY_POSTER_URL_STRING @"http://slurm.trakt.us/images/poster-dark"
#define BANNER_ASPECT_RATIO (758 / 140.0)
#define EMPTY_BANNER_URL_STRING @"http://slurm.trakt.us/images/banner"


@interface TVMainViewController () <iCarouselDataSource, iCarouselDelegate, UITableViewDataSource, UITableViewDelegate> {
    TVShowStore *_sharedShowStore;
    iCarousel *_carouselView;
    
    UIColor *_fontColor;
    
    UIButton *_menuButton;
    
    UILabel *_todayLabel;
    UITableView *_todayTableView;
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
    Swap(&mainScreen.size.height, &mainScreen.size.width);
    self.view.backgroundColor = [UIColor blackColor];
    // init
    _fontColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    // Menu button
    CGFloat menuButtonX = 20;
    CGFloat menuButtonY = 20;
    CGFloat menuButtonWdith = 50;
    CGFloat menuButtonHeight = 40;
    CGRect menuButtonRect = CGRectMake(menuButtonX, menuButtonY, menuButtonWdith, menuButtonHeight);
    _menuButton = [[UIButton alloc] initWithFrame:menuButtonRect];
    [_menuButton setBackgroundColor:[UIColor whiteColor]];
    [_menuButton setTitle:@"Menu" forState:UIControlStateNormal];
    [_menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Carousel View
    CGFloat mainCarouselViewX = 0;
    CGFloat mainCarouselViewY = 0;
    CGFloat mainCarouselViewWidth = mainScreen.size.width;
    CGFloat mainCarouselViewHeight = mainScreen.size.height * 0.45;
    CGRect mainCarouselViewRect = CGRectMake(mainCarouselViewX, mainCarouselViewY, mainCarouselViewWidth, mainCarouselViewHeight);
    _carouselView = [[iCarousel alloc] initWithFrame:mainCarouselViewRect];
    [_carouselView setType:iCarouselTypeLinear];
    [_carouselView setDataSource:self];
    [_carouselView setDelegate:self];
    [_carouselView setBounces:NO];
//    [_mainCarouselView setDecelerationRate:0.9];
//    [_mainCarouselView setBounceDistance:0.7];
    [_carouselView setCenterItemWhenSelected:NO];
    [_carouselView setContentOffset:CGSizeMake(- (mainCarouselViewWidth - mainCarouselViewHeight * POSTER_ASPECT_RATIO) / 2, 0)];
    [_carouselView setBackgroundColor:[UIColor blackColor]];
    
    // Today Label View
    CGFloat todayLabelX = mainCarouselViewX;
    CGFloat todayLabelY = mainCarouselViewY + mainCarouselViewHeight;
    CGFloat todayLabelWidth = mainScreen.size.width * 1/3;
    CGFloat todayLabelHeight = 40;
    CGRect todayLabelRect = CGRectMake(todayLabelX, todayLabelY, todayLabelWidth, todayLabelHeight);
    _todayLabel = [[UILabel alloc] initWithFrame:todayLabelRect];
    [_todayLabel setText:@"Today"];
    [_todayLabel setTextAlignment:NSTextAlignmentCenter];
    [_todayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [_todayLabel setBackgroundColor:[UIColor lightGrayColor]];
    [_todayLabel setTextColor:_fontColor];
    
    // Today table view
    CGFloat todayTableViewX = todayLabelX;
    CGFloat todayTableViewY = todayLabelY + todayLabelHeight;
    CGFloat todayTableViewWidth = todayLabelWidth;
    CGFloat todayTableviewHeight = mainScreen.size.height - mainCarouselViewHeight - todayLabelHeight;
    CGRect todayTableViewRect = CGRectMake(todayTableViewX, todayTableViewY, todayTableViewWidth, todayTableviewHeight);
    _todayTableView = [[UITableView alloc] initWithFrame:todayTableViewRect];
    _todayTableView.dataSource = self;
    _todayTableView.delegate = self;
    [_todayTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    [self.view addSubview:_carouselView];
    [self.view addSubview:_menuButton];
    [self.view addSubview:_todayLabel];
    [self.view addSubview:_todayTableView];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 

- (void)menuButtonTapped:(id)sender {
    TVShowDetailsViewController *v = [[TVShowDetailsViewController alloc] init];
    [v setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [v setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:v animated:YES completion:nil];
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
