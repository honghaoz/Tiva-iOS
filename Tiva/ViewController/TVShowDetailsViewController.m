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

@interface TVShowDetailsViewController ()

@property (nonatomic, strong) TVShow *theShow;
@property (nonatomic, strong) UIImageView *showImage;

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
    [super viewDidLoad];
    [showTitle setText:_theShow.title]; // Change this to be dynamic
    //UIScrollView *scrollView = [[UIScrollView alloc]init];
    
    //[self.view addSubview:scrollView];
    //UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
     //NSLog(@"Image %d ",  _showImage.bounds.size.width);
    
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

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Pick Friends button handler
- (IBAction)pickFriendsClick:(UIButton *)sender {
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
             }
             message = text;
         }
         
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
