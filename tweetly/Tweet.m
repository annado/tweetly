//
//  TweetCell.m
//  tweetly
//
//  Created by Anna Do on 03/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSDate *)date {
    return nil;
}

- (NSString *)text {
    return @"";
}

- (NSString *)name {
    return @"";
}

- (NSString *)username {
    return @"";
}

- (NSInteger)retweetCount {
    return 0;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    return tweets;
}

@end
