//
//  TweetCell.m
//  tweetly
//
//  Created by Anna Do on 03/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

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
    }
    self.retweetLabel.hidden = !tweet.retweet;
    self.nameLabel.text = _tweet.name;
    self.usernameLabel.text = _tweet.usernameLabel;
    self.tweetLabel.text = _tweet.text;
//    self.timestampLabel.text = [self relativeDateStringForDate:_tweet.date];
}

static NSInteger TweetLabelMaxWidth = 218;
static NSInteger ActionViewHeight = 22;
static NSInteger NameLabelHeight = 16;
static NSInteger RetweetLabelHeight = 15 + 2;
static NSInteger CellVerticalPadding = 0;

+ (NSInteger)displayHeightForTweet:(Tweet *)tweet
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
    NSInteger tweetHeight = [tweet.text boundingRectWithSize:CGSizeMake(TweetLabelMaxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    
    NSInteger height = tweetHeight + ActionViewHeight + NameLabelHeight + CellVerticalPadding;
    if (tweet.retweet) {
        height += RetweetLabelHeight;
    }
    return height;
}

@end
