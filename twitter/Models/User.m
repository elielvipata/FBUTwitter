//
//  User.m
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/11/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageURL = dictionary[@"profile_image_url"];
        self.followers = [NSString stringWithFormat:@"%@", dictionary[@"followers_count"]];
        self.following = [NSString stringWithFormat:@"%@", dictionary[@"friends_count"]];
//        self.description = dictionary[@"description"];
//        NSLog(@"%@",dictionary[@"description"]);
    }
    return self;
}

@end
