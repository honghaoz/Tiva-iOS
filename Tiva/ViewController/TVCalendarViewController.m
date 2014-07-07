//
//  TVCalendarViewController.m
//  Tiva
//
//  Created by Zhang Honghao on 6/22/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVCalendarViewController.h"
#import "TVShowStore.h"
#import "TVCalendarShowView.h"
#import "TVMainViewController.h"
#import "TVHelperMethods.h"
#import "TVRoundedButton.h"

@interface TVCalendarViewController ()

@end

@implementation TVCalendarViewController {
    
}

- (id)init {
    self = [super init];
    if (self) {
//        TVCalendarShowView *calendarView = [[TVCalendarShowView alloc] init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationItem setTitle:@"Calendar"];
//    UIBarButtonItem *doneBarbuttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
//    [self.navigationItem setRightBarButtonItem:doneBarbuttonItem];
    
//    NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
    
    CGFloat parentViewX = GAP_WIDTH;
    CGFloat parentViewY = 20;
    CGFloat parentViewWidth = self.view.bounds.size.height - GAP_WIDTH * 2;
    CGFloat parentViewHeight = self.view.bounds.size.width - 20 - GAP_WIDTH;
    CGRect parentViewFrame = CGRectMake(parentViewX, parentViewY, parentViewWidth, parentViewHeight);
    UIView *parentView = [[UIView alloc] initWithFrame:parentViewFrame];
    [TVHelperMethods setMaskTo:parentView byRoundingCorners:UIRectCornerAllCorners withRadius:5.0];
    
    CGFloat calendarTitleX = 0;
    CGFloat calendarTitleY = 0;
    CGFloat calendarTitleWidth = parentViewWidth;
    CGFloat calendarTitleHeight = 44;
    CGRect calendarTitleFrame = CGRectMake(calendarTitleX, calendarTitleY, calendarTitleWidth, calendarTitleHeight);
    UIView *calendarTitleView = [[UIView alloc] initWithFrame:calendarTitleFrame];
    [calendarTitleView setBackgroundColor:LABEL_COLOR];
    [parentView addSubview:calendarTitleView];
    
    // Caledar label view
    CGFloat calendarLabelWidth = 120;
    CGFloat calendarLabelHeight = 44;
    CGFloat calendarLabelX = (calendarTitleWidth - calendarLabelWidth) / 2;
    CGFloat calendarLabelY = (calendarTitleHeight - calendarLabelHeight) / 2;
    CGRect calendarLabelFrame = CGRectMake(calendarLabelX, calendarLabelY, calendarLabelWidth, calendarLabelHeight);
    UILabel *calendarLabel = [[UILabel alloc] initWithFrame:calendarLabelFrame];
    [calendarLabel setText:@"Calendar"];
    [calendarLabel setTextAlignment:NSTextAlignmentCenter];
    [calendarLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21]];
    [calendarLabel setBackgroundColor:LABEL_COLOR];
    [calendarLabel setTextColor:FONT_COLOR];
    [calendarTitleView addSubview:calendarLabel];
    
    // Calendar button
    CGFloat doneButtonWidth = 85;
    CGFloat doneButtonHeight = 30;
    CGFloat doneButtonY = (calendarTitleHeight - doneButtonHeight) / 2;
    CGFloat doneButtonX = calendarTitleWidth - doneButtonWidth - doneButtonY;
    CGRect doneButtonFrame = CGRectMake(doneButtonX, doneButtonY, doneButtonWidth, doneButtonHeight);
    TVRoundedButton *doneButton = [[TVRoundedButton alloc] initWithFrame:doneButtonFrame];
    [doneButton setBackgroundColor:[UIColor clearColor]];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    //    [_doneButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    //    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [calendarTitleView addSubview:doneButton];
    
    CGFloat calendarViewX = calendarTitleX;
    CGFloat calendarViewY = calendarTitleY + calendarTitleHeight;
    CGFloat calendarViewWidth = calendarTitleWidth;
    CGFloat calendarViewHeight = parentViewHeight - (calendarTitleY + calendarTitleHeight);
    CGRect calendarViewFrame = CGRectMake(calendarViewX, calendarViewY, calendarViewWidth, calendarViewHeight);
    
    TVCalendarShowView *calendarView = [[TVCalendarShowView alloc] initWithFrame:calendarViewFrame titles:[self titlesForDay:[NSDate date] numberOfDaysBefore:6 numberOfDaysAfter:6] columnWidth:240];
    [parentView addSubview:calendarView];
    
    [self.view addSubview:parentView];
    [self.view setBackgroundColor:[UIColor blackColor]];
//    self.view = newCalendarView;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    [calendarView moveToToday];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigation methods

- (void)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper methods

- (NSMutableArray *)titlesForDay:(NSDate *)date numberOfDaysBefore:(NSInteger)daysBefore numberOfDaysAfter:(NSInteger)daysAfter {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSDateFormatter *formatter = [TVHelperMethods localDateFormatter];
    [formatter setDateFormat:@"EEEE, MMM dd"];
    
    for (int i = daysBefore; i > 0; i--) {
        NSDate *theDay = [[NSDate date] dateByAddingTimeInterval:-(60 * 60 * 24) * i];
        [titles addObject:[formatter stringFromDate:theDay]];
    }
    [titles addObject:[formatter stringFromDate:[NSDate date]]];
    for (int i = 1; i <= daysAfter; i++) {
        NSDate *theDay = [[NSDate date] dateByAddingTimeInterval:(60 * 60 * 24) * i];
        [titles addObject:[formatter stringFromDate:theDay]];
    }
    return titles;
}

@end
