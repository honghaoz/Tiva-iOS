//
//  TVShowDetailsViewController.m
//  Tiva
//
//  Created by Kanishk Prasad on 6/19/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVShowDetailsViewController.h"
#import "TVShow.h"

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
    
    UITextView *overview = [[UITextView alloc]initWithFrame:CGRectMake(_showImage.bounds.size.width + 15, 150,200,200)];
     NSLog(@"over %@ ", _theShow.overview);
    [overview setText:_theShow.overview];
    [self.view addSubview:overview];
    
    //UILabel *network
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
