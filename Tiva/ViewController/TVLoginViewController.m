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
#import "TVUser.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TVAppDelegate.h"

@interface TVLoginViewController ()

@end

@implementation TVLoginViewController {
    ZHHMainScrollView *_mainScrollView;
    UIView *_signUpView;
    UIView *_signInView;
    UILabel *_tivaLabel;
    
    TVRoundedButton *_signUpButton;
    TVRoundedButton *_signInButton;
    UIButton *_skip;
    
    TVRoundedButton *_backButton;
    UITextField *_user;
    UITextField *_password;
    TVRoundedButton *_loginInButton;
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
    
    // Sign up view
    CGFloat signUpViewX = 0;
    CGFloat signUpViewY = 0;
    CGFloat signUpViewWidth = self.view.bounds.size.width;
    CGFloat signUpViewHeight = self.view.bounds.size.height;
    CGRect signUpViewFrame = CGRectMake(signUpViewX, signUpViewY, signUpViewWidth, signUpViewHeight);
    _signUpView = [[UIView alloc] initWithFrame:signUpViewFrame];
    [_signUpView setBackgroundColor:LABEL_COLOR];
    _signUpView.clipsToBounds = YES;
    
    // Tiva Label
    CGFloat tivaLabelWidth = 200;
    CGFloat tivaLabelHeight = 100;
    CGFloat tivaLabelX = (signUpViewWidth - tivaLabelWidth) / 2;
    CGFloat tivaLabelY = (signUpViewHeight - tivaLabelHeight) / 2 - 160;
    CGRect tivaLabelFrame = CGRectMake(tivaLabelX, tivaLabelY, tivaLabelWidth, tivaLabelHeight);
    _tivaLabel = [[UILabel alloc] initWithFrame:tivaLabelFrame];
    [_tivaLabel setBackgroundColor:[UIColor clearColor]];
    [_tivaLabel setText:@"Tiva"];
    [_tivaLabel setTextAlignment:NSTextAlignmentCenter];
    [_tivaLabel setTextColor:FONT_COLOR];
    [_tivaLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:110]];
    
    // Sign in button
    CGFloat signInButtonWidth = 100;
    CGFloat signInButtonHeight = 40;
    CGFloat signInButtonX = (signUpViewWidth - signInButtonWidth) / 2;;
    CGFloat signInButtonY = tivaLabelY + tivaLabelHeight + 80;
    CGRect signInFrame = CGRectMake(signInButtonX, signInButtonY, signInButtonWidth, signInButtonHeight);
    _signInButton = [[TVRoundedButton alloc] initWithFrame:signInFrame borderColor:FONT_COLOR backgroundColor:LABEL_COLOR];
    [_signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
    [_signInButton addTarget:self action:@selector(signInButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_signUpView addSubview:_signInButton];
    
    // Sign up button
    CGFloat signUpButtonWidth = signInButtonWidth;
    CGFloat signUpButtonHeight = signInButtonHeight;
    CGFloat signUpButtonX = signInButtonX;
    CGFloat signUpButtonY = signInButtonY + signInButtonHeight + 20;
    CGRect signUpFrame = CGRectMake(signUpButtonX, signUpButtonY, signUpButtonWidth, signUpButtonHeight);
    _signUpButton = [[TVRoundedButton alloc] initWithFrame:signUpFrame borderColor:FONT_COLOR backgroundColor:LABEL_COLOR];
    [_signUpButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [_signUpButton addTarget:self action:@selector(signUpButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_signUpView addSubview:_signUpButton];
//    NSLog(@"%@", NSStringFromCGRect(_signUpButton.frame));
    
    // Skip button
    CGFloat skipX = signUpButtonX;
    CGFloat skipY = signUpButtonY + signUpButtonHeight + 20;
    CGFloat skipWidth = signUpButtonWidth;
    CGFloat skipHeight = signUpButtonHeight;
    CGRect skipFrame = CGRectMake(skipX, skipY, skipWidth, skipHeight);
    _skip = [[UIButton alloc] initWithFrame:skipFrame];
    [_skip setTitle:@"Skip" forState:UIControlStateNormal];
    [_skip setTitleColor:FONT_COLOR forState:UIControlStateNormal];
    [_skip setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateHighlighted];
    [_skip setBackgroundColor:[UIColor clearColor]];
    [_skip.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [_skip addTarget:self action:@selector(skipButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_signUpView addSubview:_skip];
    NSLog(@"%@", NSStringFromCGRect(_skip.frame));
    
    // Sign in view
    CGFloat signInViewX = signUpViewWidth;
    CGFloat signInViewY = 0;
    CGFloat signInViewWidth = self.view.bounds.size.width;
    CGFloat signInViewHeight = self.view.bounds.size.height;
    CGRect signInViewFrame = CGRectMake(signInViewX, signInViewY, signInViewWidth, signInViewHeight);
    _signInView = [[UIView alloc] initWithFrame:signInViewFrame];
    [_signInView setBackgroundColor:LABEL_COLOR];
    
    _mainScrollView = [[ZHHMainScrollView alloc] initWithFrame:self.view.bounds contentViewWithViews:@[_signUpView, _signInView] direction:ScrollHorizontal];
    [self.view addSubview:_mainScrollView];
    [self.view addSubview:_tivaLabel];
    // FB Login
    FBLoginView *loginView =[[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
    loginView.delegate = self;
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), self.view.frame.size.height - 80);
    [self.view addSubview:loginView];
}

// User logged in
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"User is in");
    NSLog(@"Username: %@", user.username);
    TVAppDelegate *theAppDelegate = (TVAppDelegate *) [UIApplication sharedApplication].delegate;
    
    //[theAppDelegate setFbUserName:user.username];
    // ---------------THIS IS FAKE!!! CHANGE IT----------------
    [theAppDelegate setFbUserName:@"alice"];
   // [self dismissViewControllerAnimated:YES completion:NO];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark - Navigation methods

- (void)signInButtonTapped:(id)sender {
    LogMethod;
    
    CGFloat userFieldWidth = 150;
    CGFloat userFieldHeight = 35;
    CGFloat userFieldX = (_signInView.bounds.size.width - userFieldWidth) / 2;
    CGFloat userFieldY =  _tivaLabel.frame.origin.y + _tivaLabel.bounds.size.height + 50; //_signInView.bounds.size.height / 2 - 80;
    CGRect userFieldFrame = CGRectMake(userFieldX, userFieldY, userFieldWidth, userFieldHeight);
    _user = [[UITextField alloc] initWithFrame:userFieldFrame];
    [_user setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [_user setTextColor:[UIColor whiteColor]];
    [_user setTextAlignment:NSTextAlignmentLeft];
    
    [_user setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.3], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:18]}]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(userFieldX, userFieldY + userFieldHeight, userFieldWidth, 1)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [_signInView addSubview:_user];
    [_signInView addSubview:lineView];
    
    CGFloat passwordFieldWidth = 150;
    CGFloat passwordFieldHeight = 35;
    CGFloat passwordFieldX = (_signInView.bounds.size.width - passwordFieldWidth) / 2;
    CGFloat passwordFieldY = userFieldY + userFieldHeight + 10;
    CGRect passwordFieldFrame = CGRectMake(passwordFieldX, passwordFieldY, passwordFieldWidth, passwordFieldHeight);
    _password = [[UITextField alloc] initWithFrame:passwordFieldFrame];
    [_password setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [_password setTextColor:[UIColor whiteColor]];
    [_password setTextAlignment:NSTextAlignmentLeft];
    
    [_password setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.3], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:18]}]];
    [_password setSecureTextEntry:YES];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(passwordFieldX, passwordFieldY + passwordFieldHeight, passwordFieldWidth, 1)];
    [lineView1 setBackgroundColor:[UIColor whiteColor]];
    
    [_signInView addSubview:_password];
    [_signInView addSubview:lineView1];
    
    // Back button
    CGFloat backButtonWidth = 40;
    CGFloat backButtonHeight = backButtonWidth;
    CGFloat backButtonX = (_signInView.bounds.size.width - backButtonWidth) / 2 - 60;
    CGFloat backButtonY = passwordFieldY + passwordFieldHeight + 20;
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonWidth, backButtonHeight);
    _backButton = [[TVRoundedButton alloc] initWithFrame:backButtonFrame borderColor:FONT_COLOR backgroundColor:LABEL_COLOR radius:backButtonWidth / 2];
    [_backButton setTitle:@"<" forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_signInView addSubview:_backButton];
    
    // Sign in button
    CGFloat loginButtonWidth = 100;
    CGFloat loginButtonHeight = 40;
    CGFloat loginButtonX = (_signInView.bounds.size.width - loginButtonWidth) / 2 + 30;
    CGFloat loginButtonY = passwordFieldY + passwordFieldHeight + 20;
    CGRect loginFrame = CGRectMake(loginButtonX, loginButtonY, loginButtonWidth, loginButtonHeight);
    _loginInButton = [[TVRoundedButton alloc] initWithFrame:loginFrame borderColor:FONT_COLOR backgroundColor:LABEL_COLOR];
    [_loginInButton setTitle:@"Login" forState:UIControlStateNormal];
    [_loginInButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_signInView addSubview:_loginInButton];
    
    [_mainScrollView moveToViewIndex:1 animated:YES];
}

- (void)signUpButtonTapped:(id)sender {
    
}

- (void)skipButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NO];
}

- (void)loginButtonTapped:(id)sender {
    TVUser *sharedUser = [TVUser sharedUser];
    [sharedUser setUsername:_user.text andPassword:_password.text];
    NSLog(@"%@",sharedUser.username);
    NSLog(@"%@",sharedUser.password);
    [sharedUser login];
    [self dismissViewControllerAnimated:YES completion:NO];
}

- (void)backButtonTapped:(id)sender {
    [_mainScrollView moveToViewIndex:0 animated:YES];
}

#pragma mark - Helper methods

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
    UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
    UIColor *colorThree = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
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
