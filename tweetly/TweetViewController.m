//
//  TweetViewController.m
//  tweetly
//
//  Created by Anna Do on 3/30/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TweetViewController.h"
#import "Tweet.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRetweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFavoritesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_tweet) {
        if (_tweet.retweet) {
            self.retweetLabel.text = _tweet.retweetLabel;
        } else {
            NSLayoutConstraint *constraint = self.retweetLabel.constraints[0];
            constraint.constant = 0.f;
        }
        
        self.nameLabel.text = _tweet.name;
        self.usernameLabel.text = [_tweet getUsernameLabel];
        self.tweetLabel.text = _tweet.text;
        [self.avatarImageView setImageWithURL:_tweet.avatarURL];
        self.numRetweetsLabel.text = [@(_tweet.retweetCount) stringValue];
        self.numFavoritesLabel.text = [@(_tweet.favoriteCount) stringValue];
        self.timestampLabel.text = _tweet.displayDate;
    }
}

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
}

@end
