//
//  TVLoginViewController.m
//  Tiva
//
//  Created by Zhang Honghao on 6/23/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVLoginViewController.h"
#import "TVMainViewController.h"
#import "ZHHMainScrollView.h"
#import "TVRoundedButton.h"

@interface TVLoginViewController ()

@end

@implementation TVLoginViewController {
    ZHHMainScrollView *_mainScrollView;
    UIView *_signUpView;
    UIView *_signInView;
    UILabel *_tivaLabel;
    TVRoundedButton *_signUpButton;
    TVRoundedButton *_signInButton;
    
    UITextField *_user;
    UITextField *_password;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:LABEL_COLOR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateSubViews {
    // Do any additional setup after loading the view.
    LogMethod;
    self.view = [[UIImageView alloc] init];
    NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
    //    [self.view.layer insertSublayer:[TVLoginViewController greyGradient] atIndex:0];
    [self.view setBackgroundColor:LABEL_COLOR];
    CGFloat signUpViewX = 0;
    CGFloat signUpViewY = 0;
    CGFloat signUpViewWidth = self.view.bounds.size.width;
    CGFloat signUpViewHeight = self.view.bounds.size.height;
    CGRect signUpViewFrame = CGRectMake(signUpViewX, signUpViewY, signUpViewWidth, signUpViewHeight);
    _signUpView = [[UIView alloc] initWithFrame:signUpViewFrame];
    [_signUpView setBackgroundColor:[UIColor redColor]];
    _signUpView.clipsToBounds = YES;
    
    CGFloat tivaLabelWidth = 200;
    CGFloat tivaLabelHeight = 100;
    CGFloat tivaLabelX = (signUpViewWidth - tivaLabelWidth) / 2;
    CGFloat tivaLabelY = 50;
    CGRect tivaLabelFrame = CGRectMake(tivaLabelX, tivaLabelY, tivaLabelWidth, tivaLabelHeight);
    
    _tivaLabel = [[UILabel alloc] initWithFrame:tivaLabelFrame];
    [_tivaLabel setBackgroundColor:[UIColor clearColor]];
    [_tivaLabel setText:@"Tiva"];
    [_tivaLabel setTextAlignment:NSTextAlignmentCenter];
    [_tivaLabel setTextColor:FONT_COLOR];
    [_tivaLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:100]];
    [_signUpView addSubview:_tivaLabel];
    
    CGFloat signInButtonWidth = 100;
    CGFloat signInButtonHeight = 40;
    CGFloat signInButtonX = (signUpViewWidth - signInButtonWidth) / 2;;
    CGFloat signInButtonY = tivaLabelY + tivaLabelHeight + 100;
    CGRect signInFrame = CGRectMake(signInButtonX, signInButtonY, signInButtonWidth, signInButtonHeight);
    _signInButton = [[TVRoundedButton alloc] initWithFrame:signInFrame borderColor:FONT_COLOR backgroundColor:LABEL_COLOR];
    [_signInButton setTitle:@"Login" forState:UIControlStateNormal];
    [_signInButton addTarget:self action:@selector(loginButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
//    [_signInButton setUserInteractionEnabled:YES];
    [_signUpView addSubview:_signInButton];
    
    NSLog(@"11 - %@", NSStringFromCGRect(_signUpView.bounds));
    NSLog(@"22 - %@", NSStringFromCGRect(_signInButton.frame));
    
//    CGFloat signUpWidth = 0;
//    CGFloat signUpHeight = 0;
//    CGFloat signUpX = 0;
//    CGFloat signUpY = 0;
//    CGRect signUpFrame = CGRectMake(signUpX, signUpY, signUpWidth, signUpHeight);
//    
//    _signUp = [[TVRoundedButton alloc] initWithFrame:signUpFrame borderColor:FONT_COLOR backgroundColor:[UIColor clearColor]];
    
    
    CGFloat signInViewX = signUpViewWidth;
    CGFloat signInViewY = 0;
    CGFloat signInViewWidth = self.view.bounds.size.width;
    CGFloat signInViewHeight = self.view.bounds.size.height;
    CGRect signInViewFrame = CGRectMake(signInViewX, signInViewY, signInViewWidth, signInViewHeight);
    _signInView = [[UIView alloc] initWithFrame:signInViewFrame];
    [_signInView setBackgroundColor:LABEL_COLOR];
    
    _mainScrollView = [[ZHHMainScrollView alloc] initWithFrame:self.view.bounds contentViewWithViews:@[_signUpView, _signInView] direction:ScrollHorizontal];
//    [self.view addSubview:_mainScrollView];
    self.view = _mainScrollView;
    [_mainScrollView addSubview:_signInButton];
}

#pragma mark - Navigation methods

- (void)loginButtonTaped:(id)sender {
    LogMethod;
    [_mainScrollView moveToViewIndex:1 animated:YES];
}

#pragma mark - Helper methods

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
    UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.02];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

- (UIImage *)radialGradientImage:(CGSize)size start:(float)start end:(float)end centre:(CGPoint)centre radius:(float)radius {
	// Render a radial background
	// http://developer.apple.com/library/ios/#documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_shadings/dq_shadings.html
    
	// Initialise
	UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
	// Create the gradient's colours
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { start,start,start, 1.0,  // Start color
		end,end,end, 1.0 }; // End color
	
	CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
	
	// Normalise the 0-1 ranged inputs to the width of the image
	CGPoint myCentrePoint = CGPointMake(centre.x * size.width, centre.y * size.height);
	float myRadius = MIN(size.width, size.height) * radius;
	
	// Draw it!
	CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
								 0, myCentrePoint, myRadius,
								 kCGGradientDrawsAfterEndLocation);
	
	// Grab it as an autoreleased image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	// Clean up
	CGColorSpaceRelease(myColorspace); // Necessary?
	CGGradientRelease(myGradient); // Necessary?
	UIGraphicsEndImageContext(); // Clean up
	return image;
}

@end
