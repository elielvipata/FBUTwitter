//
//  DetailsViewController.m
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/13/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "ProfileViewController.h"

@interface DetailsViewController ()


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.name.text = self.tweet.user.name;
    self.screenName.text = self.tweet.user.screenName;
    self.tweetText.text = self.tweet.text;
    self.favCount.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
    self.retweetCount.text =[NSString stringWithFormat:@"%d",self.tweet.retweetCount];
    self.tweetText.editable = false;
        
    
    NSString *fullPosterURL = self.tweet.user.profileImageURL;
    NSString *subString = @"https";
    subString = [subString stringByAppendingString:[fullPosterURL substringFromIndex:4]];
    NSURL *poster = [NSURL URLWithString:subString];
    [self.profileImage setImageWithURL:poster];
    [self refreshData];
}

-(void) refreshData{
    
    if(self.tweet.favorited == YES){
        [self.favIcon setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }else{
        [self.favIcon setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    
    if(self.tweet.retweeted == YES){
        [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }else{
        [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    
    self.favCount.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];

}
- (IBAction)retweetTapped:(id)sender {
    if(self.tweet.retweeted == YES){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount +=-1;
        
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweet the following Tweet: %@", tweet.text);
            }
        }];
//        self.retweetImage.image = [UIImage imageNamed:@"retweet-icon"];
    }else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
//        self.retweetImage.image = [UIImage imageNamed:@"retweet-icon-green"];
    }
    [self refreshData ];
    
}
- (IBAction)favTapped:(id)sender {
    
    if(self.tweet.favorited == YES){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount+=-1;
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }else{
        self.tweet.favorited = YES;
        self.tweet.favoriteCount +=1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    

    
    [self refreshData];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    
//    ProfileViewController * profileViewController = [sender destinationViewController];
    NSLog(@"Details");
    
}


- (IBAction)tapGesture:(id)sender {
}
@end
