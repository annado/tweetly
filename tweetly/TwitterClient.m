//
//  TwitterClient.m
//  tweetly
//
//  Created by Anna Do on 3/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "TwitterClient.h"
#import "User.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"otjebDrh7BVnTcIqIDIeg"
#define TWITTER_CONSUMER_SECRET @"pZDP03HA6xEfrXm8BEuX47XVBeDumvzWk0A2bLQ7E8I"

static NSString * const kAccessTokenKey = @"kAccessTokenKey";

@interface TwitterClient ()
@property (nonatomic, strong) BDBOAuthToken *accessToken;
@end

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *instance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:TWITTER_BASE_URL consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    });
    
    return instance;
}

- (instancetype)initWithBaseURL:(NSURL *)url consumerKey:(NSString *)key consumerSecret:(NSString *)secret {
    self = [super initWithBaseURL:TWITTER_BASE_URL consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    if (self != nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kAccessTokenKey];
        if (data) {
            NSLog(@"retrieving saved access token");
            self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return self;
}

#pragma mark Authorization Flow
- (void)authorizeWithCallback:(NSURL *)callbackUrl success:(void (^)(BDBOAuthToken *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"Authorize with callback");

    self.accessToken = nil;
    [super fetchRequestTokenWithPath:@"/oauth/request_token"
                            method:@"POST"
                       callbackURL:callbackUrl
                             scope:nil
                           success:^(BDBOAuthToken *requestToken) {
                               NSLog(@"Got request token");
                               NSString *authURL = [NSString stringWithFormat:@"oauth/authorize?oauth_token=%@", requestToken.token];
                               [[UIApplication sharedApplication] openURL:[[NSURL URLWithString:authURL relativeToURL:TWITTER_BASE_URL] absoluteURL]];
                           }
                           failure:^(NSError *error) {
                               NSLog(@"[Failed to fetch request token] - %@", error.localizedDescription);
                           }];
}

- (void)currentUserWithQuery:(NSString *)query success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"query? %@", query);
    [[TwitterClient instance] fetchAccessTokenWithPath:@"/oauth/access_token"
                                                method:@"POST"
                                          requestToken:[BDBOAuthToken tokenWithQueryString:query]
                                               success:^(BDBOAuthToken *accessToken) {
                                                   NSLog(@"accessToken: %@", accessToken.token);
                                                   [self setAccessToken:accessToken];
                                                   NSLog(@"Getting timeline...");
                                                   [self userTimelineWithSuccess:^(id response) {
                                                       NSLog(@"Got timeline: %@", response);
                                                   } failure:^(NSError *error) {
                                                       NSLog(@"failed to get timeline: %@", error);
                                                   }];
                                               }
                                               failure:^(NSError *error) {
                                                   NSLog(@"Error: %@", error.localizedDescription);
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                   message:@"Could not acquire OAuth access token. Please try again later."
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"Dismiss"
                                                                         otherButtonTitles:nil] show];
                                                   });
                                               }];
}

- (void)userTimelineWithSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *timeline = @"statuses/home_timeline.json?count=100";
    [self GET:timeline
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *tweets = (NSMutableArray *)responseObject;
          success(tweets); // TODO
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          failure(error); // TODO
      }];
}

- (void)setAccessToken:(BDBOAuthToken *)accessToken {
    if (accessToken) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAccessTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
