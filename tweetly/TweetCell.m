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
#import "User.h"
#import "TimelineViewController.h"

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet
{
    self.selectedFavoriteColor = [UIColor colorWithRed:(204/255.0f) green:(205/255.0f) blue:0 alpha:1];
    self.selectedRetweetColor = [UIColor colorWithRed:0 green:(153/255.0f) blue:0 alpha:1];
    self.defaultButtonColor = [UIColor colorWithRed:(102/255.0f) green:(102/255.0f) blue:(102/255.0f) alpha:1];
    _tweet = tweet;
    if (tweet.retweet) {
        self.retweetLabel.text = tweet.retweetLabel;
    } else {
        self.retweetLabel.text = @"";
        NSLayoutConstraint *constraint = self.retweetLabel.constraints[0];
        constraint.constant = 0.f;
    }
    
    self.nameLabel.text = _tweet.author.name;
    self.usernameLabel.text = _tweet.author.username;
    self.tweetLabel.text = _tweet.text;
    
    [self.avatarImageView setImageWithURL:_tweet.author.avatarURL];
    self.avatarImageView.layer.cornerRadius = 4;
    self.avatarImageView.clipsToBounds = YES;

    self.timestampLabel.text = [_tweet timeAgo];
    self.favoriteButton.imageView.image = [self.favoriteButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.favoriteButton.tintColor = _tweet.favorited ? self.selectedFavoriteColor : self.defaultButtonColor;
    self.retweetButton.tintColor = _tweet.retweeted ? self.selectedRetweetColor : self.defaultButtonColor;
    
    [self setupTapRecognizer];
}

- (void)setupTapRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [self.avatarImageView addGestureRecognizer:tap];
}

- (void)onTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.delegate tweetCell:self didSelectProfileForUser:_tweet.author];
}

static NSInteger TweetLabelMaxWidth = 218;
static NSInteger ActionViewHeight = 30;
static NSInteger NameLabelHeight = 18;
static NSInteger RetweetLabelHeight = 16;
static NSInteger CellVerticalPadding = 10;

+ (NSInteger)displayHeightForTweet:(Tweet *)tweet
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:13],NSFontAttributeName, nil];
    NSInteger tweetHeight = [tweet.text boundingRectWithSize:CGSizeMake(TweetLabelMaxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;

    NSInteger height = tweetHeight + ActionViewHeight + NameLabelHeight + CellVerticalPadding;
    if (tweet.retweet) {
        height += RetweetLabelHeight;
    }
    return height;
}

- (IBAction)onReplyButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowComposerNotification object:@{@"replyTweet": _tweet}];
}

- (IBAction)onRetweetButton:(id)sender {
    [_tweet retweetWithSuccess:^(Tweet *tweet) {
        [self updateRetweetButton];
    } failure:nil];
}

- (IBAction)onFavoriteButton:(id)sender {
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
