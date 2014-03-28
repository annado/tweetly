//
//  TwitterClient.h
//  tweetly
//
//  Created by Anna Do on 3/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BDBOAuth1Manager/BDBOAuth1RequestOperationManager.h>

@interface TwitterClient : BDBOAuth1RequestOperationManager
@property (nonatomic, strong) BDBOAuth1RequestSerializer *requestSerializer;
@property (nonatomic, assign, readonly, getter = isAuthorized) BOOL authorized;

#pragma mark Initialization
- (instancetype)initWithBaseURL:(NSURL *)url
                    consumerKey:(NSString *)key
                 consumerSecret:(NSString *)secret;

#pragma mark Deauthorize
- (BOOL)deauthorize;

#pragma mark Authorization Flow
- (void)fetchRequestTokenWithPath:(NSString *)requestPath
                           method:(NSString *)method
                      callbackURL:(NSURL *)callbackURL
                            scope:(NSString *)scope
                          success:(void (^)(BDBOAuthToken *requestToken))success
                          failure:(void (^)(NSError *error))failure;

- (void)fetchAccessTokenWithPath:(NSString *)accessPath
                          method:(NSString *)method
                    requestToken:(BDBOAuthToken *)requestToken
                         success:(void (^)(BDBOAuthToken *accessToken))success
                         failure:(void (^)(NSError *error))failure;
@end
