//
//  TweetCell.m
//  tweetly
//
//  Created by Anna Do on 03/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Tweet : NSObject

@property (nonatomic, strong, readonly) NSString *id;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *displayDate;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) BOOL retweet;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, strong, readonly) NSString *retweetLabel;

@property (nonatomic, strong) User *author;

+ (NSDateFormatter *)dateFormatter;
+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)timeAgo;
- (void)retweetWithSuccess:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure;
- (void)favoriteWithSuccess:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure;
@end
