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
@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

- (void)authorizeWithCallback:(NSURL *)callbackUrl success:(void (^)(BDBOAuthToken *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)currentUserWithQuery:(NSString *)query success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure;
- (void)userTimelineWithSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
@end
