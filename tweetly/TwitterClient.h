//
//  TwitterClient.h
//  tweetly
//
//  Created by Anna Do on 3/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BDBOAuth1Manager/BDBOAuth1RequestOperationManager.h>

@class User;
@class Tweet;

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;
- (void)logIn;
- (void)logout;
- (void)oAuthCallbackWithURL:(NSURL *)url;
- (void)timelineWithSuccess:(void (^)(NSMutableArray *tweets))success failure:(void (^)(NSError *error))failure;
- (void)postTweet:(NSString *)tweet success:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure;
- (void)postRetweet:(NSString *)tweetID success:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure;
- (void)deleteRetweet:(NSString *)tweetID success:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure;
- (void)postFavorite:(NSString *)tweetID success:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure;
- (void)deleteFavorite:(NSString *)tweetID success:(void (^)(Tweet *tweet))success failure:(void (^)(NSError *error))failure;
@end
