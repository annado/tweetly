//
//  User.m
//  tweetly
//
//  Created by Anna Do on 3/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "User.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User ()
@property (nonatomic, strong) NSDictionary *dictionary;
@end

@implementation User

- initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }
    return self;
}

static User *currentUser;

+ (User *)currentUser
{
    if (!currentUser) {
        
        currentUser = [[User alloc] init];
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user
{
    currentUser = user;
}

@end
