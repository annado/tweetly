//
//  TweetCell.m
//  tweetly
//
//  Created by Anna Do on 03/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TwitterClient.h"
#import "TweetCell.h"
#import "Tweet.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;


@property (nonatomic, strong) UIColor *selectedFavoriteColor;
@property (nonatomic, strong) UIColor *selectedRetweetColor;
@property (nonatomic, strong) UIColor *defaultButtonColor;

- (IBAction)onReplyButton:(id)sender;
- (IBAction)onFavoriteButton:(id)sender;
- (IBAction)onRetweetButton:(id)sender;
@end

@implementation TweetCell

- (void)setTweet:(Tweet *)tweet
{
    self.selectedFavoriteColor = [UIColor colorWithRed:(204/255.0f) green:(205/255.0f) blue:0 alpha:1];
    self.selectedRetweetColor = [UIColor colorWithRed:0 green:(153/255.0f) blue:0 alpha:1];
    self.defaultButtonColor = [UIColor colorWithRed:(102/255.0f) green:(102/255.0f) blue:(102/255.0f) alpha:1];
    _tweet = tweet;
    if (tweet.retweet) {
        self.retweetLabel.text = tweet.retweetLabel;
    } else {
        NSLayoutConstraint *constraint = self.retweetLabel.constraints[0];
        constraint.constant = 0.f;
    }
    
    self.nameLabel.text = _tweet.name;
    self.usernameLabel.text = [_tweet getUsernameLabel];
    self.tweetLabel.text = _tweet.text;
    [self.avatarImageView setImageWithURL:_tweet.avatarURL];
//    self.timestampLabel.text = [self relativeDateStringForDate:_tweet.date];
    self.favoriteButton.imageView.image = [self.favoriteButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.favoriteButton.tintColor = _tweet.favorited ? self.selectedFavoriteColor : self.defaultButtonColor;
    self.retweetButton.tintColor = _tweet.retweeted ? self.selectedRetweetColor : self.defaultButtonColor;
}

static NSInteger TweetLabelMaxWidth = 218;
static NSInteger ActionViewHeight = 16 + 20;
static NSInteger NameLabelHeight = 16 + 4;
static NSInteger RetweetLabelHeight = 16;
static NSInteger CellVerticalPadding = 0;

+ (NSInteger)displayHeightForTweet:(Tweet *)tweet
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:14],NSFontAttributeName, nil];
    NSInteger tweetHeight = [tweet.text boundingRectWithSize:CGSizeMake(TweetLabelMaxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;

    NSInteger height = tweetHeight + ActionViewHeight + NameLabelHeight + CellVerticalPadding;
    if (tweet.retweet) {
        height += RetweetLabelHeight;
    } else {
        height += 0;
    }
    return height;
}

- (IBAction)onReplyButton:(id)sender {
    NSLog(@"Reply");
}

- (IBAction)onRetweetButton:(id)sender {
    if (_tweet.retweeted) {
        // TODO
    } else {
        [[TwitterClient instance] postRetweet:_tweet.id success:^(Tweet *tweet) {
            self.retweetButton.tintColor = self.selectedRetweetColor;
            _tweet.retweeted = YES;
        } failure:^(NSError *error) {
        }];
    }
}

- (IBAction)onFavoriteButton:(id)sender {
    if (_tweet.favorited) {
        [[TwitterClient instance] deleteFavorite:_tweet.id success:^(Tweet *tweet) {
            self.favoriteButton.tintColor = self.defaultButtonColor;
            _tweet.favorited = NO;
        } failure:^(NSError *error) {
        }];
    } else {
        [[TwitterClient instance] postFavorite:_tweet.id success:^(Tweet *tweet) {
            self.favoriteButton.tintColor = self.selectedFavoriteColor;
            _tweet.favorited = YES;
        } failure:^(NSError *error) {
        }];
    }
}

@end
