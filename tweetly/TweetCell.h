//
//  TweetCell.m
//  tweetly
//
//  Created by Anna Do on 03/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;
@class User;

@interface TweetCell : UITableViewCell
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id delegate;
+ (NSInteger)displayHeightForTweet:(Tweet *)tweet;
@end

@protocol TweetCellDelegate <NSObject>

- (void)tweetCell:(TweetCell *)tweetCell didSelectProfileForUser:(User *)user;

@end
