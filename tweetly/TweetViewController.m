//
//  TweetViewController.m
//  tweetly
//
//  Created by Anna Do on 3/30/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TweetViewController.h"
#import "TimelineViewController.h" // TODO: how to get const
#import "Tweet.h"
#import "TwitterClient.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRetweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFavoritesLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) UIColor *selectedFavoriteColor;
@property (nonatomic, strong) UIColor *selectedRetweetColor;
@property (nonatomic, strong) UIColor *defaultButtonColor;
- (IBAction)onReplyButton:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFavorite:(id)sender;
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
    self.selectedFavoriteColor = [UIColor colorWithRed:(204/255.0f) green:(205/255.0f) blue:0 alpha:1];
    self.selectedRetweetColor = [UIColor colorWithRed:0 green:(153/255.0f) blue:0 alpha:1];
    self.defaultButtonColor = [UIColor colorWithRed:(102/255.0f) green:(102/255.0f) blue:(102/255.0f) alpha:1];
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
        self.favoriteButton.tintColor = _tweet.favorited ? self.selectedFavoriteColor : self.defaultButtonColor;
        self.retweetButton.tintColor = _tweet.retweeted ? self.selectedRetweetColor : self.defaultButtonColor;
    }
}

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
}

- (IBAction)onReplyButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowComposerNotification object:@{@"replyTweet": _tweet}];
}

- (IBAction)onRetweet:(id)sender {
    [_tweet retweetWithSuccess:^(Tweet *tweet) {
        [self updateRetweetButton];
    } failure:nil];
}

- (IBAction)onFavorite:(id)sender {
    [_tweet favoriteWithSuccess:^(Tweet *tweet) {
        [self updateFavoriteButton];
    } failure:nil];

}
- (void)updateRetweetButton
{
    self.retweetButton.tintColor = _tweet.retweeted ? self.selectedRetweetColor : self.defaultButtonColor;
}

- (void)updateFavoriteButton
{
    self.favoriteButton.tintColor = _tweet.favorited ? self.selectedFavoriteColor : self.defaultButtonColor;
}

@end
