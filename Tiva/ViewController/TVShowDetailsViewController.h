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
@property (weak, nonatomic) IBOutlet UIButton *AddListButton;
@property (weak, nonatomic) IBOutlet UIButton *RemoveListButton;
@property (weak, nonatomic) IBOutlet UIButton *RecButton;
@property (weak, nonatomic) IBOutlet UILabel *commentsLable;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextbox;
@property (weak, nonatomic) IBOutlet UIButton *commentSendButton;
@property (weak, nonatomic) IBOutlet UIButton *addToListButton;
@property (weak, nonatomic) IBOutlet UIButton *removeFromListButton;

- (void)setShow:(TVShow *)theShow;
- (void)setShowImage:(UIImageView *)showImage;
- (IBAction)addPressed:(id)sender;
- (IBAction)removePressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)commentButtonPressed:(id)sender;
- (IBAction)pickFriendsClick:(UIButton *)sender;


@end
