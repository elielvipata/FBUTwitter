//
//  ReplyViewController.h
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/15/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ReplyViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ReplyViewController : UIViewController

@property (nonatomic, weak) id<ReplyViewControllerDelegate> delegate;
@property (strong, nonatomic) Tweet * tweet;

@end

NS_ASSUME_NONNULL_END
