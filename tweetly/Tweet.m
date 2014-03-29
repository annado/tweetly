//
//  TweetCell.m
//  tweetly
//
//  Created by Anna Do on 03/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _date = dictionary[@"created_at"];
        _text = dictionary[@"text"];

        NSDictionary *retweet = dictionary[@"retweeted_status"];
        NSDictionary *user;
        if (retweet) {
            user = retweet[@"user"];
            _retweet = YES;
            _retweetLabel = [NSString stringWithFormat:@"%@ retweeted", dictionary[@"user"][@"name"]];
        } else {
            NSLog(@"not a retweet: %@", _text);
            user = dictionary[@"user"];
            _retweet = NO;
        }
        _name = user[@"name"];
        _username = user[@"screen_name"];
        
        _retweetCount = [dictionary[@"retweet_count"] integerValue];
    }
    return self;
}

- (NSString *)getUsernameLabel
{
    return [NSString stringWithFormat:@"@%@", _username];
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dict]];
    }
    return tweets;
}

@end
