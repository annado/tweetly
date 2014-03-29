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
        _name = dictionary[@"user"][@"name"];
        _username = dictionary[@"user"][@"screen_name"];
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
