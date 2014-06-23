//
//  TVCalendarShowView.m
//  Tiva
//
//  Created by Zhang Honghao on 6/22/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVCalendarShowView.h"
#import "TVShowStore.h"
#import "TVShow.h"
#import "TVEpisode.h"

#define NAVIGATION_BAR_HEIGHT 44
#define STATUS_BAR_HEIGHT 20
#define TITLE_NORMAL_COLOR [UIColor colorWithRed:0.31 green:0.67 blue:0.78 alpha:1]
#define TITLE_HEIGHTLIGHT_COLOR [UIColor colorWithRed:0 green:0.51 blue:0.67 alpha:1]
#define GREY_BACKGROUND_COLOR [UIColor colorWithRed:0.94 green:0.93 blue:0.92 alpha:1]

@interface TVCalendarShowView () <UIScrollViewDelegate>

@end

@implementation TVCalendarShowView {
    UIScrollView *_titleScrollView;
    UIScrollView *_mainScrollView;
    CGFloat _titleHeight;
    CGFloat _episodeHeight;
    
    TVShowStore *_mainStore;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSMutableArray *)titles
                  columnWidth:(CGFloat )width {
    self = [super initWithFrame:frame];
    if (self) {
        CGSize mainViewSize = frame.size;
        _titleHeight = 40;
        _episodeHeight = 100;
        _mainStore = [TVShowStore sharedStore];

        // Set title scroll view
        CGFloat titleScrollViewX = 0;
        CGFloat titleScrollViewY = 0;// NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT;
        CGFloat titleScrollViewWidth = mainViewSize.width;
        CGFloat titleScrollViewHeight = _titleHeight;

        CGRect titleScrollFrame = CGRectMake(titleScrollViewX, titleScrollViewY, titleScrollViewWidth, titleScrollViewHeight);
        _titleScrollView = [[UIScrollView alloc] initWithFrame:titleScrollFrame];
        [_titleScrollView setShowsHorizontalScrollIndicator:NO];
        [_titleScrollView setShowsVerticalScrollIndicator:NO];
        [_titleScrollView setDelegate:self];

        NSInteger titlesCount = [titles count];
        [_titleScrollView setContentSize:CGSizeMake(width * titlesCount, _titleHeight)];
  
        for (int i = 0; i < titlesCount; i++) {
            NSString *eachTitle = titles[i];
            UILabel *eachLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 0, width, _titleHeight)];
            [eachLabel setText:eachTitle];
            [eachLabel setTextAlignment:NSTextAlignmentCenter];
            [eachLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
            [eachLabel setBackgroundColor:TITLE_NORMAL_COLOR];
            [eachLabel setTextColor:[UIColor whiteColor]];
            [_titleScrollView addSubview:eachLabel];
        }
        
        // Set main scroll view
        CGFloat mainScrollViewX = 0;
        CGFloat mainScrollViewY = titleScrollViewY + titleScrollViewHeight;
        CGFloat mainScrollViewWidth = mainViewSize.width;
        CGFloat mainScrollViewHeight = mainViewSize.height - (titleScrollViewY + titleScrollViewHeight);
        CGRect mainScrollFrame = CGRectMake(mainScrollViewX, mainScrollViewY, mainScrollViewWidth, mainScrollViewHeight);
        _mainScrollView = [[UIScrollView alloc] initWithFrame:mainScrollFrame];
        [_mainScrollView setBackgroundColor:[UIColor whiteColor]];
        [_mainScrollView setDelegate:self];
        
        NSInteger maxNumberOfEpisodes = 0;
        NSMutableArray *dateKeys = [self dateKeysForDay:[NSDate date] numberOfDaysBefore:6 numberOfDaysAfter:6];
        
        NSInteger dateKeysCount = [dateKeys count];
        for (int i = 0; i < dateKeysCount; i++) {
            NSDate *key = [dateKeys objectAtIndex:i];
            NSArray *episodes = (NSArray *)[_mainStore.episodesDictionary objectForKey:key];
            if (episodes) {
                NSInteger episodesCount = [episodes count];
                NSLog(@"ep count: %d", episodesCount);
                if (episodesCount > maxNumberOfEpisodes) {
                    maxNumberOfEpisodes = episodesCount;
                }
                for (int j = 0; j < episodesCount; j++) {
                    TVEpisode *eachEpisode = (TVEpisode *)episodes[j];
                    UIView *episodeView = [[UIView alloc] initWithFrame:CGRectMake(i * width, j * _episodeHeight, width, _episodeHeight)];
                    CGFloat showLabelX = 10;
                    CGFloat showLabelY = 10;
                    CGFloat showLabelWidth = width - 20;
                    CGFloat showLabelHeight = 20;
                    CGRect showLabelFrame = CGRectMake(showLabelX, showLabelY, showLabelWidth, showLabelHeight);
                    UILabel *showLabel = [[UILabel alloc] initWithFrame:showLabelFrame];
                    [showLabel setText:eachEpisode.show.title];
                    [showLabel setTextAlignment:NSTextAlignmentLeft];
                    [showLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
                    [showLabel setBackgroundColor:[UIColor clearColor]];
                    [showLabel setTextColor:TITLE_NORMAL_COLOR];
                    
                    CGFloat timeLabelX = showLabelX;
                    CGFloat timeLabelY = showLabelY + showLabelHeight + 10;
                    CGFloat timeLabelWidth = width - 20;
                    CGFloat timeLabelHeight = 20;
                    CGRect timeLabelFrame = CGRectMake(timeLabelX, timeLabelY, timeLabelWidth, timeLabelHeight);
                    UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeLabelFrame];
                    NSDateFormatter *formater = [TVShowStore localDateFormatter];
                    [formater setDateFormat:@"hh:mm aa"];
                    
                    [timeLabel setText:[formater stringFromDate:eachEpisode.airedDateUTC]];
                    [timeLabel setTextAlignment:NSTextAlignmentLeft];
                    [timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
                    [timeLabel setBackgroundColor:[UIColor clearColor]];
                    [timeLabel setTextColor:[UIColor darkGrayColor]];
                    
                    [episodeView addSubview:timeLabel];
                    [episodeView addSubview:showLabel];
                    
                    if (j % 2 == 0) {
                        [episodeView setBackgroundColor:GREY_BACKGROUND_COLOR];
                    }
                    [_mainScrollView addSubview:episodeView];
                }
            }
        }
        
        [_mainScrollView setContentSize:CGSizeMake(width * dateKeysCount, _episodeHeight * maxNumberOfEpisodes)];
        
        [self addSubview:_titleScrollView];
        [self addSubview:_mainScrollView];
    }
    return self;
}

//
//- (void)drawRect:(CGRect)rect
//{
//    LogMethod;
//    // Drawing code
//}

#pragma mark - Scroll view delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _titleScrollView) {
        CGFloat offsetX = _titleScrollView.contentOffset.x;
        CGPoint offset = _mainScrollView.contentOffset;
        offset.x = offsetX;
        [_mainScrollView setContentOffset:offset];
    } else {
        CGFloat offsetX = _mainScrollView.contentOffset.x;
        CGPoint offset = _titleScrollView.contentOffset;
        offset.x = offsetX;
        [_titleScrollView setContentOffset:offset];
    }
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

- (NSMutableArray *)dateKeysForDay:(NSDate *)date numberOfDaysBefore:(NSInteger)daysBefore numberOfDaysAfter:(NSInteger)daysAfter {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    for (int i = daysBefore; i > 0; i--) {
        NSDate *theDay = [[NSDate date] dateByAddingTimeInterval:-(60 * 60 * 24) * i];
        [keys addObject:[_mainStore dateWithOutTime:theDay]];
    }
    [keys addObject:[_mainStore dateWithOutTime:[NSDate date]]];
    for (int i = 1; i <= daysAfter; i++) {
        NSDate *theDay = [[NSDate date] dateByAddingTimeInterval:(60 * 60 * 24) * i];
        [keys addObject:[_mainStore dateWithOutTime:theDay]];
    }
    return keys;
}

@end
