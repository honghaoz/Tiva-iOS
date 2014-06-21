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
    NSMutableArray *_items;
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

- (void)setUp
{
    //set up data
    _items = [NSMutableArray array];
    for (int i = 0; i < 1000; i++)
    {
        [_items addObject:@(i)];
    }
}

- (void)loadView {
    [self setUp];
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
    [[TVShowStore sharedStore] retrieveShows];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    LogMethod;
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    LogMethod;
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
//        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //TVShow *theShow = [TVShowStore sharedStore].shows[2];
    //[theShow loadImage:theShow.posterImage withURL:theShow.posterURL];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
//    [imageView set]
    [imageView setImageWithURL:[NSURL URLWithString:@"http://slurm.trakt.us/images/posters/23330.5.jpg"]];
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [_items[index] stringValue];
    
    return imageView;
}

@end
