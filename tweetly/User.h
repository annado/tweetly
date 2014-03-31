//
//  User.h
//  tweetly
//
//  Created by Anna Do on 3/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSURL *avatarURL;
- initWithDictionary:(NSDictionary *)dictionary;
+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
@end
