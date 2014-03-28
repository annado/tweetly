//
//  TwitterClient.m
//  tweetly
//
//  Created by Anna Do on 3/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "TwitterClient.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"otjebDrh7BVnTcIqIDIeg"
#define TWITTER_CONSUMER_SECRET @"pZDP03HA6xEfrXm8BEuX47XVBeDumvzWk0A2bLQ7E8I"

static NSString * const kAccessTokenKey = @"kAccessTokenKey";

@implementation TwitterClient

+ (TwitterClient *)instance {
    static dispatch_once_t once;
    static TwitterClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:TWITTER_BASE_URL consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    });
    
    return instance;
}

- (instancetype)initWithBaseURL:(NSURL *)url
                    consumerKey:(NSString *)key
                 consumerSecret:(NSString *)secret
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark Deauthorize
- (BOOL)deauthorize
{
    
    return NO;
}

#pragma mark Authorization Flow
- (void)fetchRequestTokenWithPath:(NSString *)requestPath
                           method:(NSString *)method
                      callbackURL:(NSURL *)callbackURL
                            scope:(NSString *)scope
                          success:(void (^)(BDBOAuthToken *requestToken))success
                          failure:(void (^)(NSError *error))failure
{
    
}

- (void)fetchAccessTokenWithPath:(NSString *)accessPath
                          method:(NSString *)method
                    requestToken:(BDBOAuthToken *)requestToken
                         success:(void (^)(BDBOAuthToken *accessToken))success
                         failure:(void (^)(NSError *error))failure
{
    
}

@end
