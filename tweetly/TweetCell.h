//
//  TweetCell.h
//  twitter
//
//  Created by Timothy Lee on 8/6/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) Tweet *tweet;
+ (NSInteger)displayHeightForTweet:(Tweet *)tweet;
@end
