//
//  ProfileViewController.h
//  tweetly
//
//  Created by Anna Do on 4/5/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

extern NSString *const ShowComposerNotification;

@interface ProfileViewController : UIViewController
@property (nonatomic, strong) User *user;
- (id)initWithUser:(User *)user;
@end
