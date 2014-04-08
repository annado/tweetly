//
//  TwitterClient.m
//  tweetly
//
//  Created by Anna Do on 3/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "TwitterClient.h"
#import "NSDictionary+BDBOAuth1Manager.h"
#import "User.h"
#import "Tweet.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"dXSzC094W9BgDIeQXpTw"
#define TWITTER_CONSUMER_SECRET @"UvQAVBS9lY2n9SagBu3U48iUzFjQe7deGMtYXzhY7U"

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
            self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return self;
}

- (void)logIn
{
    if (self.isAuthorized) {
        NSLog(@"already authorized");
        [self currentUser];
    } else {
        [self authorizeWithCallback:[NSURL URLWithString:@"tweetly://oauth"]];
    }
}

- (void)logout
{
    [self deauthorize];
    [User setCurrentUser:nil];
}

- (void)authorizeWithCallback:(NSURL *)callbackUrl
{
    self.accessToken = nil;
    [super fetchRequestTokenWithPath:@"/oauth/request_token"
                            method:@"POST"
                       callbackURL:callbackUrl
                             scope:nil
                           success:^(BDBOAuthToken *requestToken) {
                               NSLog(@"Got request token");
                               [self openOAuthWithToken:requestToken];
                           }
                           failure:^(NSError *error) {
                               [self showErrorWithMessage:@"ld not acquire OAuth access token. Please try again later."];
                           }];
}

- (void)openOAuthWithToken:(BDBOAuthToken *)requestToken
{
    NSString *authURL = [NSString stringWithFormat:@"oauth/authorize?oauth_token=%@", requestToken.token];
    [[UIApplication sharedApplication] openURL:[[NSURL URLWithString:authURL relativeToURL:TWITTER_BASE_URL] absoluteURL]];
}

- (void)oAuthCallbackWithURL:(NSURL *)url
{
    NSDictionary *parameters = [NSDictionary dictionaryFromQueryString:url.query];
    if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
        [self requestAccessToken:[BDBOAuthToken tokenWithQueryString:url.query]];
    }
}

- (void)requestAccessToken:(BDBOAuthToken *)requestToken
{
    [[TwitterClient instance] fetchAccessTokenWithPath:@"/oauth/access_token"
                                                method:@"POST"
                                          requestToken:requestToken
                                               success:^(BDBOAuthToken *accessToken) {
                                                   NSLog(@"accessToken: %@", accessToken.token);
                                                   [self setAccessToken:accessToken];
                                                   NSLog(@"Getting timeline...");
                                                   [self currentUser];
                                               }
                                               failure:^(NSError *error) {
                                                   [self showErrorWithMessage:@"Could not acquire OAuth request token. Please try again later."];
                                               }];
}

- (void)currentUser
{
    [self GET:@"1.1/account/verify_credentials.json"
        parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [User setCurrentUser:[[User alloc] initWithDictionary:responseObject]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"[currentUser] failed - %@", error);
            [self showErrorWithMessage:@"Could not verify credentials. Please try again later."];
    }];
}

- (void)timelineForUser:(User *)user success:(void (^)(NSMutableArray *tweets))success failure:(void (^)(NSError *error))failure
{
    NSString *timeline = @"1.1/statuses/user_timeline.json";
    NSDictionary *parameters = @{@"count":@20, @"user_id":[NSString stringWithFormat:@"%@", user.id]};
    [self GET:timeline
   parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *tweets = (NSMutableArray *)responseObject;
          success(tweets); // TODO
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error); // TODO
          }
      }];
}

- (void)timelineWithSuccess:(void (^)(NSMutableArray *tweets))success failure:(void (^)(NSError *error))failure
{
    NSString *timeline = @"1.1/statuses/home_timeline.json?count=20";
    [self GET:timeline
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *tweets = (NSMutableArray *)responseObject;
          success(tweets); // TODO
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error); // TODO
          }
      }];
}

- (void)mentionsWithSuccess:(void (^)(NSMutableArray *tweets))success failure:(void (^)(NSError *error))failure
{
    NSString *timeline = @"1.1/statuses/mentions_timeline.json";
    [self GET:timeline
   parameters:@{@"count" : @"20"}
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *tweets = (NSMutableArray *)responseObject;
          success(tweets); // TODO
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error); // TODO
          }
      }];
}

- (void)postTweet:(NSString *)tweet replyTo:(Tweet *)replyTweet success:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure
{
    NSString *post = @"1.1/statuses/update.json";
    NSString *replyID = replyTweet ? replyTweet.id : @"";
    [self POST:post
   parameters:@{@"status":tweet, @"in_reply_to_status_id":replyID}
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
          success(tweet); // TODO
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error); // TODO
          }
          NSLog(@"failed to postTweet: %@", error);
          [self showErrorWithMessage:@"Failed to post Tweet. Please try again later."];
      }];
}

- (void)postRetweet:(NSString *)tweetID success:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure
{
    NSString *post = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetID];
    [self POST:post
    parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
           success(tweet); // TODO
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (failure) {
               failure(error); // TODO
           }
           NSLog(@"failed to postTweet: %@", error);
           [self showErrorWithMessage:@"Failed to retweet. Please try again later."];
       }];
}

- (void)deleteRetweet:(NSString *)tweetID success:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure
{
    NSString *post = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetID];
    [self POST:post
    parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
           success(tweet); // TODO
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (failure) {
               failure(error); // TODO
           }
           NSLog(@"failed to postTweet: %@", error);
           [self showErrorWithMessage:@"Failed to delete retweet. Please try again later."];
       }];
}

- (void)postFavorite:(NSString *)tweetID success:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure
{
    NSString *post = @"1.1/favorites/create.json";
    [self POST:post
    parameters:@{@"id":tweetID}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
           success(tweet); // TODO
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (failure) {
               failure(error); // TODO
           }
           NSLog(@"failed to postTweet: %@", error);
           [self showErrorWithMessage:@"Failed to add Favorite. Please try again later."];
       }];
}

- (void)deleteFavorite:(NSString *)tweetID success:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure
{
    NSString *post = @"1.1/favorites/destroy.json";
    [self POST:post
    parameters:@{@"id":tweetID}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
           success(tweet); // TODO
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (failure) {
               failure(error); // TODO
           }
           NSLog(@"failed to delete favorite: %@", error);
           [self showErrorWithMessage:@"Failed to undo Favorite. Please try again later."];
       }];
}

#pragma mark private methods
- (void)showErrorWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:message
                                   delegate:self
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil] show];
    });
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
