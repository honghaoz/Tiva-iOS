//
//  TVShowDetailsViewController.m
//  Tiva
//
//  Created by Kanishk Prasad on 6/19/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVShowDetailsViewController.h"
#import "TVShow.h"
#import "TVShowStore.h"
#import "TVHelperMethods.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TvAppDelegate.h"
#import <Parse/Parse.h>
#import "TVUser.h"


@interface TVShowDetailsViewController ()

@property (nonatomic, strong) TVShow *theShow;
@property (nonatomic, strong) UIImageView *showImage;
@property (nonatomic, strong) NSString *fbUserid;
@property (nonatomic, strong) NSString *showID;


@end

@implementation TVShowDetailsViewController
@synthesize showPoster;
@synthesize showTitle;
@synthesize synopsisText;
@synthesize otherInfoText;
@synthesize commentsTable;
@synthesize airDateLable;
@synthesize runtimeLable;
@synthesize networkLable;
@synthesize AddListButton;
@synthesize RemoveListButton;
@synthesize RecButton;
@synthesize commentsLable;
@synthesize commentsTextbox;
@synthesize fbUserid;
@synthesize showID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        LogMethod;
    }
    return self;
}

- (void)viewDidLoad
{
    // Setting userID from app delegate
    fbUserid = [TVUser sharedUser].fbID;
    NSLog(@"fbID: %@", fbUserid);
    // Setting show ID
    showID = _theShow.objectID;
    [super viewDidLoad];
    [showTitle setText:_theShow.title]; // Change this to be dynamic

    [self.view addSubview:_showImage];
    
    UITextView *overview = [[UITextView alloc]initWithFrame:CGRectMake(_showImage.bounds.size.width + 15, 130,200,160)];
//     NSLog(@"over %@ ", _theShow.overview);
    [overview setText:_theShow.overview];
    [self.view addSubview:overview];
    
    [networkLable setText:_theShow.network];
    NSDateFormatter *formater = [TVHelperMethods localDateFormatter];
    [formater setDateFormat:@"MMM yyyy"];
    [airDateLable setText:[formater stringFromDate:_theShow.firstAiredDateUTC]];
    
    [runtimeLable setText:[NSString stringWithFormat:@"%0.0f mins",_theShow.runtime]];
    
    //UIImage *poster = theImageView.image;
    //[showPoster setImage:poster];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setShow:(TVShow *)theShow {
    _theShow = theShow;
}

- (void)setShowImage:(UIImageView *)showImage {
     // NSLog(@"URL %@ ", posterURLString);
    _showImage = showImage;
}
- (IBAction)addPressed:(id)sender{
    //Add the show object
    [PFCloud callFunctionInBackground:@"addFavourite"
                       withParameters:@{@"userID":[TVUser sharedUser].currentPFUser.objectId,@"showID":showID}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"It works");
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ is added", _theShow.title] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alertView show];
                                        [[TVUser sharedUser] retrieveFavorites];
                                    }
                                }];

  
}
- (IBAction)removePressed:(id)sender{
    // Replace the name and paramenter in the function call below to send comments.
    //    [PFCloud callFunctionInBackground:@"recommendShow"
    //                       withParameters:@{@"recommendeeID":reccomendee,@"recommenderID":reccomender,@"showID":showId}
    //                                block:^(NSString *result, NSError *error) {
    //                                    if (!error) {
    //                                        NSLog(@"SHIT FAILED YO");
    //                                    }
    //                                }];
    
}


- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)commentButtonPressed:(id)sender{
    
    NSString *comment = commentsTextbox.text;
    NSLog(@"Comment: %@, ID: %@, show: %@", comment,[TVUser sharedUser].currentPFUser.objectId,_theShow.tvdb_id);
    // send text to parse now.
    // Replace the name and paramenter in the function call below to send comments.
    //commentShow(senderID, contents, showID)
    [PFCloud callFunctionInBackground:@"commentShow"
                       withParameters:@{@"senderID":[TVUser sharedUser].currentPFUser.objectId, @"contents": comment,@"showID":_theShow.objectID}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"it works");
                                    }
                                }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

// Pick Friends button handler
- (IBAction)pickFriendsClick:(UIButton *)sender {
    //Username of the current user is stored in the app delegate.
//    TVAppDelegate *theAppDelegate = (TVAppDelegate *) [UIApplication sharedApplication].delegate;
    
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *innerSender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }
         
         NSString *message;
         
         if (friendPickerController.selection.count == 0) {
             message = @"<No Friends Selected>";
         } else {
             
             NSMutableString *text = [[NSMutableString alloc] init];
             
             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {
                 if ([text length]) {
                     [text appendString:@", "];
                 }
                 [text appendString:user.name];
                 NSLog(@"usr_id::%@",user.objectID);
                 NSLog(@"usr_first_name::%@",user.first_name);
                 NSLog(@"usr_middle_name::%@",user.middle_name);
                 NSLog(@"usr_last_nmae::%@",user.last_name);
                 NSLog(@"usr_Username::%@",user.username);
                 NSLog(@"usr_b_day::%@",user.birthday);
                 // SEND TO PARSE
                 NSString *reccomendee = user.objectID;
                 NSString *reccomender = [TVUser sharedUser].currentPFUser.objectId;
                 //NSString *showId = _theShow.tvdb_id;
                 
                 [PFCloud callFunctionInBackground:@"recommendShow" withParameters:@{@"recommendeeID":reccomendee, @"recommenderID":reccomender,@"showID":showID}
                                             block:^(NSString *result, NSError *error) {
                                                 if (!error) {
                                                     NSLog(@"SHIT Succeed YO");
                                                 } else {
                                                     NSLog(@"SHIT FAILED YO");
                                                 }
                                             }];
             }
             message = text;
         }
         // Only for debug
         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;    //count of section
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return 3;    //count number of row from counting array hear cataGorry is An Array
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *MyIdentifier = @"MyIdentifier";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
//    
//    if (cell == nil)
//    {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                       reuseIdentifier:MyIdentifier];
//    }
//    
//    // Here we use the provided setImageWithURL: method to load the web image
//    // Ensure you use a placeholder image otherwise cells will be initialized with no image
//    cell.textLabel.text = @"My Text";
//    return cell;
//}
@end
