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

@interface TVCalendarViewController ()

@end

@implementation TVCalendarViewController

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
    [self.navigationItem setTitle:@"Calendar"];
    UIBarButtonItem *doneBarbuttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    [self.navigationItem setRightBarButtonItem:doneBarbuttonItem];
    
    TVCalendarShowView *newCalendarView = [[TVCalendarShowView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width) titles:[self titlesForDay:[NSDate date] numberOfDaysBefore:6 numberOfDaysAfter:6] columnWidth:230];
//    [self.view addSubview:newCalendarView];
    self.view = newCalendarView;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    NSDateFormatter *formatter = [TVShowStore localDateFormatter];
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
