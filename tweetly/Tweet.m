//
//  TweetCell.m
//  tweetly
//
//  Created by Anna Do on 03/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    
    return dateFormatter;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSString *dateString = dictionary[@"created_at"];
        NSDateFormatter *dateFormatter = [Tweet dateFormatter];
        [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        _date = [dateFormatter dateFromString:dateString];
        _displayDate = [NSDateFormatter localizedStringFromDate:_date
                          dateStyle:NSDateFormatterShortStyle
                          timeStyle:NSDateFormatterShortStyle];

        _id = dictionary[@"id"];
        _text = dictionary[@"text"];
        _favorited = [dictionary[@"favorited"] boolValue];
        _retweeted = [dictionary[@"retweeted"] boolValue];

        NSDictionary *retweet = dictionary[@"retweeted_status"];
        NSDictionary *user;
        if (retweet) {
            user = retweet[@"user"];
            _retweet = YES;
            _retweetLabel = [NSString stringWithFormat:@"%@ retweeted", dictionary[@"user"][@"name"]];
        } else {
            user = dictionary[@"user"];
            _retweet = NO;
        }
        _name = user[@"name"];
        _username = user[@"screen_name"];
        _avatarURL = [NSURL URLWithString:user[@"profile_image_url"]];
        
        _retweetCount = [dictionary[@"retweet_count"] integerValue];
        _retweetCount = [dictionary[@"favorite_count"] integerValue];
    }
    return self;
}

- (NSString *)getUsernameLabel
{
    return [NSString stringWithFormat:@"@%@", _username];
}

- (NSString *)timeAgo
{
    NSDate *date = _date;
    NSDate *todayDate = [NSDate date];
    double ti = [date timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
    	return @"0s";
    } else 	if (ti < 60) {
    	return @"1m";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
    	return [NSString stringWithFormat:@"%dm", diff];
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
    	return[NSString stringWithFormat:@"%dh", diff];
    } else if (ti < 2629743) {
    	int diff = round(ti / 60 / 60 / 24);
    	return[NSString stringWithFormat:@"%dd", diff];
    } else {
    	return @"0s";
    }
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dict]];
    }
    return tweets;
}

@end
