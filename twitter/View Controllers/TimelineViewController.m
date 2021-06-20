//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "DateTools.h"
#import "DetailsViewController.h"
#import "InfiniteScrollActivityView.h"
#import "ProfileViewController.h"
#import "TTTAttributedLabel.h"
#import "ReplyViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate,ComposeViewControllerDelegate,TTTAttributedLabelDelegate, UIActionSheetDelegate>


@property (strong, atomic) NSMutableArray * tweetArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)  UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@end

@implementation TimelineViewController

InfiniteScrollActivityView* loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 310;
    
    self. refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
    [self loadData];
    self.isMoreDataLoading = false;
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
        loadingMoreView.hidden = true;
    [self.tableView addSubview:loadingMoreView];
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        self.tableView.contentInset = insets;
 
    

}

-(void)loadData{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
//            NSLog(@"%@", tweets[0][@"text"]);

            self.tweetArray = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            [loadingMoreView stopAnimating];
            [self.tableView reloadData];

        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }

        [self.refreshControl endRefreshing];
    }];
}

-(void)loadMoreData:(NSInteger)count{
    NSDictionary* params = @{@"count": [NSNumber numberWithInt:count]};
    
    [[APIManager shared] getMoreHomeTimelineWithCompletion:params :^(NSArray *tweets, NSError *error) {
        if (tweets) {
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
//            NSLog(@"%@", tweets[0][@"text"]);

            self.tweetArray = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");

        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }

        [self.refreshControl endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if([segue.identifier isEqualToString:@"composeSegue"]){
        UITableViewCell * tappedCell = sender;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:tappedCell];
        NSDictionary * tweet = self.tweetArray[indexPath.row];
        
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        composeController.tweet = tweet;
    }
    
    if([segue.identifier isEqualToString: @"detailSegue"]){
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:tappedCell];
        NSDictionary * tweet = self.tweetArray[indexPath.row];
        
        DetailsViewController * detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
        NSLog(@"Tapped");
    }
    
    if([segue.identifier isEqualToString:@"profileSegue"]){
        UITableViewCell * tappedCell = sender;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:tappedCell];
        NSDictionary * tweet = self.tweetArray[indexPath.row];
        
        ProfileViewController * profileViewController = [segue destinationViewController];
        profileViewController.tweet = tweet;
        NSLog(@"%d", indexPath.row);
    }
    
    if([segue.identifier isEqualToString:@"replySegue"]){
        UITableViewCell * tappedCell = sender;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet * tweet = self.tweetArray[indexPath.row];
        
        ReplyViewController * replyViewController = [segue destinationViewController];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:tweet.idStr forKey:@"idstr"];
        [defaults setValue:tweet.user.screenName forKey:@"user"];

    
    }
    
    
}

-(TTTAttributedLabel*)createLabel:(NSString *) text{
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    
    label.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    label.delegate = self; // Delegate methods are called when the user taps on a link (see `TTTAttributedLabelDelegate` protocol)

    label.text = text; // Repository URL will be automatically detected and linked
    
    return label;
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell * tweetCell = (TweetCell*)[tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet * tweet = self.tweetArray[indexPath.row];
    tweetCell.tweetText.editable = false;
    [tweetCell.profileImage addGestureRecognizer:self.tapGesture];
    tweetCell.name.text = tweet.user.name;
    tweetCell.screenName.text = tweet.user.screenName;
    tweetCell.tweetText.text = tweet.text;
    tweetCell.favoriteCount.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
    tweetCell.retweetCount.text = [NSString stringWithFormat:@"%d",tweet.retweetCount];
    tweetCell.tweetDate.text = tweet.createdAtString;
    tweetCell.tweet = tweet;
    [tweetCell refreshData];
    if(tweet.media_url == nil){
        //tweetCell.imageHeight.constant = 0;
    }else{
        //tweetCell.imageHeight.constant = 162;
        
        //Set media Image
        NSString *imageString = tweet.media_url;
        NSURL *imageURL = [NSURL URLWithString:imageString];
        [tweetCell.tweetImage setImageWithURL:imageURL];
    }

    
    NSString *dateString = tweet.dateCreated;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:dateString];
    
    tweetCell.tweetDate.text = date.shortTimeAgoSinceNow;
    
    //Set Profile Image
    NSString *fullPosterURL = tweet.user.profileImageURL;
    NSString *subString = @"https";
    subString = [subString stringByAppendingString:[fullPosterURL substringFromIndex:4]];
    
    
    NSURL *poster = [NSURL URLWithString:subString];
    [tweetCell.profileImage setImageWithURL:poster];
    
    tweetCell.profileImage.layer.cornerRadius = 45.0;
    tweetCell.profileImage.layer.masksToBounds = YES;
    
    //Done setting image
    
    //    Tweet * tweet = self.tweetArray[indexPath.row];
    
    return tweetCell;
    
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweetArray count];
}
- (IBAction)onLogoutButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}


//Replace loadMoreData with the method you created to fetch tweets

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.tweetArray count]){
        [self loadMoreData:[self.tweetArray count] + 20];
        [self.tableView reloadData];
    }
}




- (void)didTweet:(Tweet *)tweet{
    [self.tweetArray addObject:tweet];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

@end
