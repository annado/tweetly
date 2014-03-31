//
//  TweetCell.m
//  tweetly
//
//  Created by Anna Do on 03/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TweetCell.h"
#import "Tweet.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet
{
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
}

static NSInteger TweetLabelMaxWidth = 218;
static NSInteger ActionViewHeight = 22;
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
    }
    return height;
}

@end
