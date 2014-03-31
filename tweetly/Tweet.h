//
//  TweetCell.m
//  tweetly
//
//  Created by Anna Do on 03/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong, readonly) NSString *usernameLabel;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) BOOL retweet;
@property (nonatomic, strong, readonly) NSString *retweetLabel;
@property (nonatomic, strong, readonly) NSURL *avatarURL;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)getUsernameLabel;
@end
