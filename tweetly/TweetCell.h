//
//  TweetCell.m
//  tweetly
//
//  Created by Anna Do on 03/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;

@interface TweetCell : UITableViewCell
@property (nonatomic, strong) Tweet *tweet;
+ (NSInteger)displayHeightForTweet:(Tweet *)tweet;
@end
