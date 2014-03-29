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
- (void)logIn;
- (void)oAuthCallbackWithURL:(NSURL *)url;
- (void)timelineWithSuccess:(void (^)(NSMutableArray *tweets))success failure:(void (^)(NSError *error))failure;
@end
