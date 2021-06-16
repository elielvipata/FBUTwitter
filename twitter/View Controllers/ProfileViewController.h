//
//  ProfileViewController.h
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/14/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) Tweet * tweet;

@end

NS_ASSUME_NONNULL_END
