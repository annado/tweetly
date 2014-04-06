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

static NSString * const kCurrentUserKey = @"kCurrentUserKey";

- initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        _id = dictionary[@"id"];
        _name = dictionary[@"name"];
        _username = [NSString stringWithFormat:@"@%@", dictionary[@"screen_name"]];
        _avatarURL = [NSURL URLWithString:dictionary[@"profile_image_url"]];
        _backgroundURL = [NSURL URLWithString:dictionary[@"profile_background_image_url"]];
        _textHexColor = dictionary[@"profile_text_color"];
        _tweetCount = [dictionary[@"statuses_count"] intValue];
        _followerCount = [dictionary[@"followers_count"] intValue];
        _followingCount = [dictionary[@"friends_count"] intValue];
                                               
    }
    return self;
}

static User *_currentUser = nil;

+ (User *)currentUser
{
    if (!_currentUser) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser
{
    if (!currentUser) {
        
    }
    _currentUser = currentUser;
    if (currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_currentUser.dictionary options:NSJSONWritingPrettyPrinted error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
    }
}

@end
