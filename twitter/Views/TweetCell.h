//
//  TweetCell.h
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/12/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetCell.h"
#import "TTTAttributedLabel.h"


NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *retweetImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UIButton *favoriteImage;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *tweetImage;
@property (weak, nonatomic) IBOutlet UIButton *replyTweet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;


-(void)refreshData;
@end

NS_ASSUME_NONNULL_END
