//
//  ComposeViewController.m
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/12/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"


@interface ComposeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tweetTextField;
@property (weak, nonatomic) IBOutlet UILabel *numCharacters;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetTextField.delegate = self;
    
    NSString *fullPosterURL = self.tweet.user.profileImageURL;
    
//    NSString *subString = @"https";
//    subString = [subString stringByAppendingString:[fullPosterURL substringFromIndex:4]];
//    NSURL *poster = [NSURL URLWithString:subString];
//    [self.profileImage setImageWithURL:poster];
    // Do any additional setup after loading the view.
    
    self.profileImage.layer.cornerRadius = 45.0;
    self.profileImage.layer.masksToBounds = YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // TODO: Check the proposed new text character count
   // Allow or disallow the new text
    
    int characterLimit = 280;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.tweetTextField.text stringByReplacingCharactersInRange:range withString:text];

    // TODO: Update Character Count Label
    int total = newText.length;
    self.numCharacters.text = [NSString stringWithFormat:@"%d",characterLimit-total];

    // The new text should be allowed? True/False
    return newText.length < characterLimit;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onCanceButton:(id)sender {
}
- (IBAction)onTweetButton:(id)sender {
    
    NSString * text = self.tweetTextField.text;
    if(text.length != 0){
        [[APIManager shared] postStatusWithText:text completion:^(Tweet *tweet, NSError *error) {
            if(tweet){
                NSLog(@"Tweeted!");
                [self.delegate didTweet:tweet];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                NSLog(@"%@", error.localizedDescription);
            }
            
        }];
    }
    
   
}
- (IBAction)onCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
    


@end
