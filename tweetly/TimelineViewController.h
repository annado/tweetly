//
//  TimelineViewController.h
//  tweetly
//
//  Created by Anna Do on 3/29/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "TweetCell.h"

@class User;

extern NSString *const ShowComposerNotification;

@interface TimelineViewController : UIViewController <UITableViewDataSource,
    UITableViewDelegate,
    ComposeViewDelegate,
    TweetCellDelegate>
@property (nonatomic, assign) BOOL mentions;
@property (nonatomic, strong) User *user;
- (id)initWithUser:(User *)user;
@end
