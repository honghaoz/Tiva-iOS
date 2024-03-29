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
#import <UIImage+BlurredFrame.h>
#import "UIView+BackgroundBlurEffect.h"
#import "JCRBlurView.h"
#import <Parse/Parse.h>

#import "TVShowStore.h"
#import "TVShow.h"
#import "iCarousel.h"
#import "TVAPIClient.h"
#import "TVUser.h"
#import "TVShowDetailsViewController.h"
#import "TVCalendarViewController.h"
#import "TVCalendarShowView.h"
#import "TVRoundedButton.h"
#import "TVHelperMethods.h"
#import "TVLoginViewController.h"
#import "TVEpisodeTableViewCell.h"
#import <objc/runtime.h>

#define POSTER_ASPECT_RATIO (680 / 1000.0)
#define EMPTY_POSTER_URL_STRING @"http://slurm.trakt.us/images/poster-dark"
#define BANNER_ASPECT_RATIO (758 / 140.0)
#define EMPTY_BANNER_URL_STRING @"http://slurm.trakt.us/images/banner"
#define EMPTY_FANART_URL_STRING @"http://slurm.trakt.us/images/fanart-dark"

@interface TVMainViewController () <iCarouselDataSource, iCarouselDelegate, UITableViewDataSource, UITableViewDelegate> {
    CGRect _mainScreen;
    TVShowStore *_sharedShowStore;
    TVUser *_sharedUser;
    
    UIImageView *_backgroundImageView;
    
    UIView *_carouselParentView;
    iCarousel *_carouselView;
    
    TVRoundedButton *_menuButton;
    
    UIView *_todayParentView;
    UILabel *_todayLabel;
    TVRoundedButton *_calendarButton;
    UITableView *_todayTableView;
    
    UIView *_recommendationParentView;
    UILabel *_recommendationTitle;
    UITableView *_recommendationTableView;
    
    UIView *_commentsParentView;
    UILabel *_commentsTitle;
    UILabel *_emptyComments;
    UITableView *_commentsTableView;
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
    self.view = [[UIView alloc] init];
    _mainScreen = [UIScreen mainScreen].bounds;
    Swap(&_mainScreen.size.height, &_mainScreen.size.width);
    [self updateBackground];
    
    // Menu button
    CGFloat menuButtonX = 20;
    CGFloat menuButtonY = 20 + 10 ;
    CGFloat menuButtonWdith = 60;
    CGFloat menuButtonHeight = 40;
    CGRect menuButtonFrame = CGRectMake(menuButtonX, menuButtonY, menuButtonWdith, menuButtonHeight);
    _menuButton = [[TVRoundedButton alloc] initWithFrame:menuButtonFrame borderColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor]];
    [_menuButton setBackgroundColor:[UIColor blackColor]];
    [_menuButton setTitle:@"Login" forState:UIControlStateNormal];
    [_menuButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
//    [_menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Carousel parent view
    CGFloat carouselParentViewX = GAP_WIDTH;
    CGFloat carouselParentViewY = 20.0;
    CGFloat carouselParentViewWidth = _mainScreen.size.width - 2 * GAP_WIDTH;
    CGFloat carouselParentViewHeight = _mainScreen.size.height * 0.5;
    CGRect carouselParentViewFrame = CGRectMake(carouselParentViewX, carouselParentViewY, carouselParentViewWidth, carouselParentViewHeight);
    _carouselParentView = [[UIView alloc] initWithFrame:carouselParentViewFrame];
    [TVHelperMethods setMaskTo:_carouselParentView byRoundingCorners:UIRectCornerAllCorners withRadius:5.0];
    
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
    CGFloat todayViewWidth = (_mainScreen.size.width - GAP_WIDTH * 4) * 1/3;
    CGFloat todayViewHeight = _mainScreen.size.height - (carouselParentViewY +  carouselParentViewHeight) - 2 * GAP_WIDTH;
    CGRect todayViewFrame = CGRectMake(todayViewX, todayViewY, todayViewWidth, todayViewHeight);
    _todayParentView = [[UIView alloc] initWithFrame:todayViewFrame];
    [TVHelperMethods setMaskTo:_todayParentView byRoundingCorners:UIRectCornerAllCorners withRadius:5.0];
//    [_todayParentView setBackgroundColor:[UIColor clearColor]];
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
//    [_todayLabel setBackgroundColor:LABEL_COLOR];
    [_todayLabel setBackgroundColor:[UIColor clearColor]];
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _todayLabel.bounds.size.width, _todayLabel.bounds.size.height)];
//    [toolbar setBarTintColor: [UIColor colorWithRed:0. green:0.7 blue:0. alpha:0.05]];
//    [self.layer insertSublayer:[toolbar layer] atIndex:0];
//    [_todayLabel insertSubview:toolbar atIndex:0];
    
//    [_todayLabel setBlurTintColor:[UIColor colorWithRed:0. green:0.7 blue:0. alpha:0.05]];
    [_todayLabel setTextColor:FONT_COLOR];
    [_todayParentView addSubview:_todayLabel];
    
    // Calendar button
    CGFloat calendarButtonWidth = 85;
    CGFloat calendarButtonHeight = 30;
    CGFloat calendarButtonY = (todayLabelHeight - calendarButtonHeight) / 2;
    CGFloat calendarButtonX = todayViewWidth - calendarButtonWidth - calendarButtonY;
    CGRect calendarButtonFrame = CGRectMake(calendarButtonX, calendarButtonY, calendarButtonWidth, calendarButtonHeight);
    _calendarButton = [[TVRoundedButton alloc] initWithFrame:calendarButtonFrame borderColor:[UIColor whiteColor] backgroundColor:LABEL_COLOR];
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
    [_todayTableView setBackgroundColor:[UIColor clearColor]];//[UIColor colorWithWhite:0.7 alpha:1]];
    [_todayParentView addSubview:_todayTableView];
    
    // Recommendation view
    CGFloat recommendationParentViewX = todayViewX + todayViewWidth + GAP_WIDTH;
    CGFloat recommendationParentViewY = todayViewY;
    CGFloat recommendationParentViewWidth = todayViewWidth;
    CGFloat recommendationParentViewHeight = todayViewHeight;
    CGRect recommendationParentViewFrame = CGRectMake(recommendationParentViewX, recommendationParentViewY, recommendationParentViewWidth, recommendationParentViewHeight);
    _recommendationParentView = [[UIView alloc] initWithFrame:recommendationParentViewFrame];
    [TVHelperMethods setMaskTo:_recommendationParentView byRoundingCorners:UIRectCornerAllCorners withRadius:5.0];
    
    // Recommendation label view
    CGFloat recommendationTitleX = 0;
    CGFloat recommendationTitleY = 0;
    CGFloat recommendationTitleWidth = recommendationParentViewWidth;
    CGFloat recommendationTitleHeight = 44;
    CGRect recommendationTitleFrame = CGRectMake(recommendationTitleX, recommendationTitleY, recommendationTitleWidth, recommendationTitleHeight);
    
    _recommendationTitle = [[UILabel alloc] initWithFrame:recommendationTitleFrame];
    [_recommendationTitle setText:@"Friends' Recommendation"];
    [_recommendationTitle setTextAlignment:NSTextAlignmentCenter];
    [_recommendationTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21]];
    [_recommendationTitle setBackgroundColor:[UIColor clearColor]];
    [_recommendationTitle setTextColor:FONT_COLOR];
    [_recommendationParentView addSubview:_recommendationTitle];
    
    // Recommendation table view
    CGFloat recommendationTableViewX = recommendationTitleX;
    CGFloat recommendationTableViewY = recommendationTitleHeight;
    CGFloat recommendationTableViewWidth = recommendationParentViewWidth;
    CGFloat recommendationTableViewHeight = recommendationParentViewHeight - recommendationTitleHeight;
    CGRect recommendationTableViewFrame = CGRectMake(recommendationTableViewX, recommendationTableViewY, recommendationTableViewWidth, recommendationTableViewHeight);

    _recommendationTableView = [[UITableView alloc] initWithFrame:recommendationTableViewFrame];
    _recommendationTableView.dataSource = self;
    _recommendationTableView.delegate = self;
//    [_recommendationTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_recommendationTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_recommendationTableView setBackgroundColor:[UIColor clearColor]];
    [_recommendationParentView addSubview:_recommendationTableView];
    
    
    // Comments view
    CGFloat commentsParentViewX = recommendationParentViewX + recommendationParentViewWidth + GAP_WIDTH;
    CGFloat commentsParentViewY = recommendationParentViewY;
    CGFloat commentsParentViewWidth = recommendationParentViewWidth;
    CGFloat commentsParentViewHeight = recommendationParentViewHeight;
    CGRect commentsParentViewFrame = CGRectMake(commentsParentViewX, commentsParentViewY, commentsParentViewWidth, commentsParentViewHeight);
    _commentsParentView = [[UIView alloc] initWithFrame:commentsParentViewFrame];
    [TVHelperMethods setMaskTo:_commentsParentView byRoundingCorners:UIRectCornerAllCorners withRadius:5.0];
    
    // Comments label view
    CGFloat commentsTitleX = 0;
    CGFloat commentsTitleY = 0;
    CGFloat commentsTitleWidth = commentsParentViewWidth;
    CGFloat commentsTitleHeight = 44;
    CGRect commentsTitleFrame = CGRectMake(commentsTitleX, commentsTitleY, commentsTitleWidth, commentsTitleHeight);
    
    _commentsTitle = [[UILabel alloc] initWithFrame:commentsTitleFrame];
    [_commentsTitle setText:@"Latest Comments"];
    [_commentsTitle setTextAlignment:NSTextAlignmentCenter];
    [_commentsTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21]];
    [_commentsTitle setBackgroundColor:[UIColor clearColor]];
    [_commentsTitle setTextColor:FONT_COLOR];
    [_commentsParentView addSubview:_commentsTitle];

    
    _emptyComments = [[UILabel alloc] initWithFrame:CGRectOffset(commentsTitleFrame, 0, commentsTitleHeight + 120)];
    [_emptyComments setText:@"No comments available"];
    [_emptyComments setTextAlignment:NSTextAlignmentCenter];
    [_emptyComments setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21]];
    [_emptyComments setBackgroundColor:[UIColor clearColor]];
    [_emptyComments setTextColor:FONT_COLOR];
    [_commentsParentView addSubview:_emptyComments];
    
    // Recommendation table view
    CGFloat commentsTableViewX = 0;
    CGFloat commentsTableViewY = commentsTitleHeight;
    CGFloat commentsTableViewWidth = commentsParentViewWidth;
    CGFloat commentsTableViewHeight = (commentsParentViewHeight - commentsTitleHeight);
    CGRect commentsTableViewFrame = CGRectMake(commentsTableViewX, commentsTableViewY, commentsTableViewWidth, commentsTableViewHeight);
    
    _commentsTableView = [[UITableView alloc] initWithFrame:commentsTableViewFrame];
    _commentsTableView.dataSource = self;
    _commentsTableView.delegate = self;
    [_commentsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_commentsTableView setBackgroundColor:[UIColor clearColor]];
    [_commentsParentView addSubview:_commentsTableView];
    
    
    [self.view addSubview:_carouselParentView];
    [self.view addSubview:_menuButton];
    [self.view addSubview:_todayParentView];
    [self.view addSubview:_recommendationParentView];
    [self.view addSubview:_commentsParentView];
}

- (void)updateBackground {
    UIImage *img = [UIImage imageNamed:@"1372240878_breaking_bad.jpeg"];
//    if ([_sharedShowStore.shows count] > 0) {
//        TVShow *randomShow = [_sharedShowStore.shows objectAtIndex: arc4random() % [_sharedShowStore.shows count]];
//        img = [UIImage imag]
//    }
    CGRect frame = CGRectMake(0, 0, img.size.width, img.size.height);
    
    img = [img applyDarkEffectAtFrame:frame];
    img = [TVHelperMethods imageWithImage:img scaledToSize:_mainScreen.size];
    
//    _backgroundImageView = [[UIImageView alloc] initWithImage:img];
//    self.view = _backgroundImageView;
//
    UIColor *background = [[UIColor alloc] initWithPatternImage:img];
    self.view.backgroundColor = background;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sharedShowStore = [TVShowStore sharedStore];
    _sharedUser = [TVUser sharedUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStoreUpdates:) name:@"ShowStoreUpdated" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recommendationShowsUpdated:) name:@"RecommendationUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentsUpdated:) name:@"CommentsUpdated" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCarouselShowsUpdates:) name:@"FavouriteShowUpdated" object:_sharedUser];
//    _sharedUser.username = @"alice";
//    _sharedUser.password = @"a";
//    [_sharedUser login];
//    [_sharedUser retrieveUserData];
//    [_sharedShowStore retrieveShows];
    [_sharedShowStore retrieveEpisodesFromDay:[NSDate date] toDay:[NSDate date]];
    [_sharedShowStore retrieveComments];
//    [[TVTraktUser sharedUser] setUsername:@"honghaoz" andPassword:@"Zhh358279765099"];
//    [[TVAPIClient sharedClient] testUsername:[TVTraktUser sharedUser].username passwordSha1:[TVTraktUser sharedUser].passwordSha1 success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"success: %@", responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"failure: %@", error);
//    }];
    
    [self setNeedsStatusBarAppearanceUpdate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self menuButtonTapped:nil];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * 1e9), dispatch_get_current_queue(),^{
        [_sharedShowStore retrieveEpisodesFromDay:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * (-3)] toDay:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 3]];
    });
    
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
//    [_sharedUser login];
//    [_sharedUser retrieveUserData];
    TVLoginViewController *loginVC = [[TVLoginViewController alloc] init];
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [loginVC setModalPresentationStyle:UIModalPresentationFormSheet];
    
//    UIPopoverController *popVC = [[UIPopoverController alloc] initWithContentViewController:loginVC];
//    [popVC presentPopoverFromRect:_menuButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//
    [self presentViewController:loginVC animated:YES completion:^(){
        [loginVC updateSubViews];
    }];
    
//    [PFCloud callFunctionInBackground:@"getShowComments"
//                       withParameters:@{@"tvdb_id" : @"268583"}
//                                block:^(NSString *result, NSError *error) {
//                                    if (!error) {
//                                        // result is @"Hello world!"
//                                        NSLog(@"%@", result);
//                                    }
//                                }];
    
}

- (void)calendarButtonTapped:(id)sender {
    LogMethod;
    [_sharedShowStore processEpisodesDictionary];
    TVCalendarViewController *calendarVC = [[TVCalendarViewController alloc] init];

    [calendarVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [calendarVC setModalPresentationStyle:UIModalPresentationFullScreen];
    [calendarVC.view setBounds:CGRectMake(GAP_WIDTH, 20, _mainScreen.size.width - 2 * GAP_WIDTH, _mainScreen.size.height - GAP_WIDTH - 20)];
    [self presentViewController:calendarVC animated:YES completion:nil];
//    [_sharedShowStore retrieveEpisodesForDay:[NSDate date]];
//    [_sharedUser retrieveRecommendations];
}

#pragma mark - NSNotificationCenter methods

- (void)showStoreUpdates:(NSNotification *)notification {
    NSLog(@"Received ShowStoreUpdated");
    NSDictionary *userInfo = notification.userInfo;
    // If data kind is for today
    if ([userInfo[@"DataKind"] isEqualToString:@"Episodes"]
        &&
        [userInfo[@"BeginDay"] isEqualToDate:[TVHelperMethods dateWithOutTime:[NSDate date]]]
        && [userInfo[@"EndDay"] isEqualToDate:[TVHelperMethods dateWithOutTime:[NSDate date]]]) {
        [_todayTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
//    [_recommendationTableView reloadData];
}

- (void)recommendationShowsUpdated:(NSNotification *)notification {
    LogMethod;
    [_recommendationTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)commentsUpdated:(NSNotification *)notification {
    LogMethod;
    if ([_sharedShowStore.comments count] > 0) {
        _emptyComments.text = @"";
    }
    [_commentsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)iCarouselShowsUpdates:(NSNotification *)notification {
    [_carouselView reloadData];
}

#pragma mark - iCarousel data source methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return [_sharedShowStore.shows count];
//    NSLog(@"%d", [_sharedUser.favouriteShows count]);
    return [_sharedUser.favouriteShows count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    UIImageView *theImageView = (UIImageView *)view;
    
    if (theImageView == nil) {
        theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _carouselView.bounds.size.height * POSTER_ASPECT_RATIO, _carouselView.bounds.size.height)];
        [theImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    [theImageView cancelImageRequestOperation];
//    NSString *posterURLString = [[_sharedShowStore.shows[index] posterURL] absoluteString];
    NSString *posterURLString = [[_sharedUser.favouriteShows[index] posterURL] absoluteString];
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

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"Cell has been selected.");
    
//    TVLoginViewController *loginVC = [[TVLoginViewController alloc] init];
//    [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    [loginVC setModalPresentationStyle:UIModalPresentationFormSheet];
//    
//    //    UIPopoverController *popVC = [[UIPopoverController alloc] initWithContentViewController:loginVC];
//    //    [popVC presentPopoverFromRect:_menuButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    //
//    [self presentViewController:loginVC animated:YES completion:^(){
//        [loginVC updateSubViews];
//    }];
    NSString *posterURLString = [[_sharedUser.favouriteShows[index] posterURL] absoluteString];
    
    posterURLString = [posterURLString stringByReplacingOccurrencesOfString:@".jpg" withString:@"-300.jpg"];
    
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _carouselView.bounds.size.height * POSTER_ASPECT_RATIO, _carouselView.bounds.size.height)];
    //[theImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    NSLog(@"URL %@ ", posterURLString);
    [theImageView setImageWithURL:[NSURL URLWithString:posterURLString]];
    
    TVShowDetailsViewController *detailScreen = [[TVShowDetailsViewController alloc] init];
    
    [detailScreen setShowImage:theImageView];
    [detailScreen setShow:(TVShow *)_sharedUser.favouriteShows[index]];
    detailScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
     [detailScreen setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:detailScreen animated:YES completion:nil];
    
}
#pragma mark - Today table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    LogMethod;
    if (tableView == _todayTableView) {
//        return [_sharedShowStore.shows count];
//        NSLog(@"%d", [_sharedShowStore.todayEpisodes count]);
        return [_sharedShowStore.todayEpisodes count];
    } else if (tableView == _recommendationTableView) {
//        return [_sharedShowStore.shows count];
//        NSLog(@"%d", [_sharedUser.recommendations count]);
        return [_sharedUser.recommendations count];
    } else if (tableView == _commentsTableView) {
        return [_sharedShowStore.comments count];
    }
    else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    LogMethod;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LogMethod;
    if (tableView == _todayTableView) {
        TVEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayShow"];
        if (cell == nil) {
            cell = [[TVEpisodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TodayShow" cellWidth:tableView.bounds.size.width cellHeight:50];
        }
        TVEpisode *episode = _sharedShowStore.todayEpisodes[indexPath.row];
        TVShow *theShow = episode.show;
//        NSLog(@"%@", theShow.title);
        [cell setShowTitle:theShow.title airedTime:episode.airedDateUTC];
        return cell;
    }
    else if (tableView == _recommendationTableView) {
//        NSLog(@"recommendation table viwe cell");
        TVEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendationShow"];
        if (cell == nil) {
            cell = [[TVEpisodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendationShow" cellWidth:tableView.bounds.size.width cellHeight:50];
        }
        TVShow *theShow = _sharedUser.recommendations[indexPath.row];
//        NSLog(@"%@", theShow.title);
        PFObject *recommender = objc_getAssociatedObject(theShow, @"Recommender");
        [cell setShowTitle:theShow.title detailText:[NSString stringWithFormat:@"recommended by %@ %@", recommender[@"fbFirstName"], recommender[@"fbLastName"]]];
//        NSLog(@"%@", cell.showTitleLabel.text);
//        NSLog(@"Return cell");
        return cell;

//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayShow"];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TodayShow"];
//        
////            CGRect bannerRect = CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.width / BANNER_ASPECT_RATIO);
////            bannerImageView = [[UIImageView alloc] initWithFrame:bannerRect];
////            [bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
////            [cell.contentView addSubview:bannerImageView];
//        }
//        cell.textLabel.text = [array1 objectAtIndex:indexPath.row];
//        [cell.textLabel setTextColor:LABEL_COLOR];
//        cell.detailTextLabel.text = [array2 objectAtIndex:indexPath.row];
//        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        //cell.textLabel.text = @"abc";
//        for (UIView *subView in cell.contentView.subviews) {
//            if ([subView isKindOfClass:[UIImageView class]]) {
//                bannerImageView =  (UIImageView *)subView;
//            }
//        }
//        [bannerImageView cancelImageRequestOperation];
//        [bannerImageView setImage:[self imageWithRect:bannerImageView.bounds.size color:[UIColor lightGrayColor]]];
//        NSString *bannerURLString = [[_sharedShowStore.shows[indexPath.row] bannerURL] absoluteString];
//        if (![bannerURLString vt_containsSubstring:EMPTY_BANNER_URL_STRING]) {
//            //        [bannerImageView setImage:[self imageWithRect:bannerImageView.bounds.size color:[UIColor lightGrayColor]]];
//        } else {
//            [bannerImageView setImageWithURL:[_sharedShowStore.shows[indexPath.row] bannerURL]];
//        }
//    return cell;
    } else if (tableView == _commentsTableView) {
        TVEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comment"];
        if (cell == nil) {
            cell = [[TVEpisodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Comment" cellWidth:tableView.bounds.size.width cellHeight:50];
        }
        
        NSString *content = _sharedShowStore.comments[indexPath.row];
        NSString *sender = objc_getAssociatedObject(content, @"sender");
        TVShow *show = objc_getAssociatedObject(content, @"show");
        
        [cell setShowTitle:content detailText:[NSString stringWithFormat:@"%@ by %@", show.title, sender]];
        //        NSLog(@"%@", cell.showTitleLabel.text);
        //        NSLog(@"Return cell");
        return cell;
    }
    
    else {
        return nil;
    }
}

#pragma mark - table view delegate

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (tableView == _todayTableView) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 5.0)];
//        [view setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.2]];
//        return view;
//    }
//    return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _todayTableView) {
        return 50;
    } else if (tableView == _recommendationTableView) {
//        NSLog(@"recommendation table viwe height");
//        return tableView.bounds.size.width / BANNER_ASPECT_RATIO;
        return 50;
//        return 44;
    } else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _todayTableView) {
//        TVShow *theShow = _sharedShowStore.shows[indexPath.row];
        TVEpisode *selectedEpisode = _sharedShowStore.todayEpisodes[indexPath.row];
        TVShow *theShow = selectedEpisode.show;
    
        NSString *posterURLString = [theShow.posterURL absoluteString];
        posterURLString = [posterURLString stringByReplacingOccurrencesOfString:@".jpg" withString:@"-300.jpg"];
        
        UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _carouselView.bounds.size.height * POSTER_ASPECT_RATIO, _carouselView.bounds.size.height)];
        [theImageView setImageWithURL:[NSURL URLWithString:posterURLString]];
        
        TVShowDetailsViewController *detailScreen = [[TVShowDetailsViewController alloc] init];
        [detailScreen setShowImage:theImageView];
        [detailScreen setShow:theShow];
        detailScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [detailScreen setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:detailScreen animated:YES completion:nil];
    }
}
//
//#pragma mark - UIControl methods
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
//}

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
