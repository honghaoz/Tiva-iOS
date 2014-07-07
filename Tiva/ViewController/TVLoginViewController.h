//
//  TVLoginViewController.h
//  Tiva
//
//  Created by Zhang Honghao on 6/23/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface TVLoginViewController : UIViewController <FBLoginViewDelegate>

- (void)updateSubViews;

@end
