//
//  InfiniteScrollActivityView.h
//  FBUTwitter
//
//  Created by Vipata Kilembo on 6/14/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfiniteScrollActivityView : UIView
@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;
@end

NS_ASSUME_NONNULL_END
