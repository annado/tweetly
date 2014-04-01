//
//  ComposeViewController.h
//  tweetly
//
//  Created by Anna Do on 3/30/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;

@interface ComposeViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSString *replyID;
@property (nonatomic, strong) Tweet *replyTweet;
@end

@protocol ComposeViewDelegate <NSObject>
- (void)composeViewController:(ComposeViewController *)composeViewController
                postedTweet:(Tweet *)tweet;
@end