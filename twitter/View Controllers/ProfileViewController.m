//
//  ProfileViewController.m
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/14/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tagLine;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.name.text = self.tweet.user.name;
    self.screenName.text = self.tweet.user.screenName;
    self.tagLine.text = self.tweet.user.description;
    
    NSString *fullPosterURL = self.tweet.user.profileImageURL;
    NSString *subString = @"https";
    subString = [subString stringByAppendingString:[fullPosterURL substringFromIndex:4]];
    NSURL *poster = [NSURL URLWithString:subString];
    [self.profileImage setImageWithURL:poster];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
