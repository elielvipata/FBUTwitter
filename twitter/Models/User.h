//
//  User.h
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/11/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic,strong) NSString *profileImageURL;
@property (nonatomic,assign) NSMutableString *description;
@property (nonatomic,assign) NSString *tweets;
@property (nonatomic,assign) NSString *following;
@property (nonatomic,assign) NSString *followers;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
