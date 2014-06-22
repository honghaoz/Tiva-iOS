//
//  TVShowDetailsViewController.m
//  Tiva
//
//  Created by Kanishk Prasad on 6/19/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVShowDetailsViewController.h"

@interface TVShowDetailsViewController ()

@end

@implementation TVShowDetailsViewController
@synthesize showPoster;
@synthesize showTitle;
@synthesize synopsisText;
@synthesize otherInfoText;
@synthesize commentsTable;

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
    [showTitle setText:@"Breaking Bad"]; // Change this to be dynamic
    UIImage *poster = [UIImage imageNamed: @"1372240878_breaking_bad.jpeg"];
    [showPoster setImage:poster];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
