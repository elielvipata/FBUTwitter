//
//  MentionsViewController.m
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/15/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "MentionsViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"



@interface MentionsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, atomic) NSMutableArray * tweetArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    [[APIManager shared] getMentionsTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
//            NSLog(@"%@", tweets[0][@"text"]);

            self.tweetArray = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            [self.tableView reloadData];

        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }

    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell * tweetCell = (TweetCell*)[tableView dequeueReusableCellWithIdentifier:@"MentionCell" forIndexPath:indexPath];
    
    Tweet * tweet = self.tweetArray[indexPath.row];
    
    tweetCell.name.text = tweet.user.name;
    tweetCell.screenName.text = tweet.user.screenName;
    tweetCell.tweetText.text = tweet.text;
    tweetCell.favoriteCount.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
    tweetCell.retweetCount.text = [NSString stringWithFormat:@"%d",tweet.retweetCount];
    tweetCell.tweetDate.text = tweet.createdAtString;
    tweetCell.tweet = tweet;
    [tweetCell refreshData];
    if(tweet.media_url == nil){
//        CGRect newFrame = tweetCell.tweetImage.frame;
//
//        newFrame.size.width = 0;
//        newFrame.size.height = 0;
//        [tweetCell.tweetImage setFrame:newFrame];
    }else{
        //Set Profile Image
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
