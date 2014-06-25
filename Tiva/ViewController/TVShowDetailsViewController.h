//
//  TVShowDetailsViewController.h
//  Tiva
//
//  Created by Kanishk Prasad on 6/19/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TVShow;

@interface TVShowDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *showPoster;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UITextView *synopsisText;
@property (weak, nonatomic) IBOutlet UITextView *otherInfoText;
@property (weak, nonatomic) IBOutlet UITableView *commentsTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bottomMenu;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *airDateLable;
@property (weak, nonatomic) IBOutlet UILabel *networkLable;
@property (weak, nonatomic) IBOutlet UILabel *runtimeLable;

- (void)setShow:(TVShow *)theShow;
- (void)setShowImage:(UIImageView *)showImage;
- (IBAction)doneButtonPressed:(id)sender;

@end
