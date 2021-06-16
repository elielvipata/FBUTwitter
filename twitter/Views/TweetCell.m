//
//  TweetCell.m
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/12/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@protocol TweetCellDelegate
// TODO: Add required methods the delegate needs to implement
- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;
@end

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImage addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImage setUserInteractionEnabled:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapRetweet:(id)sender {
    
    if(self.tweet.retweeted == YES){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount +=-1;
        
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
//        self.retweetImage.image = [UIImage imageNamed:@"retweet-icon"];
    }else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
//        self.retweetImage.image = [UIImage imageNamed:@"retweet-icon-green"];
    }
    [self refreshData ];

}
- (IBAction)didTapFavorite:(id)sender {
    
    
    if(self.tweet.favorited == YES){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount+=-1;
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
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


-(void) refreshData{
    
    if(self.tweet.favorited == YES){
        [self.favoriteImage setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }else{
        [self.favoriteImage setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    
    if(self.tweet.retweeted == YES){
        [self.retweetImage setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }else{
        [self.retweetImage setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    
    self.favoriteCount.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];

}


@end
