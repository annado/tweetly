//
//  TweetCell.m
//  twitter
//
//  Created by Timothy Lee on 8/6/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TweetCell.h"

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
    if (tweet.retweetCount == 0) {
        [self.retweetLabel setHidden:YES];
    }
    self.nameLabel.text = _tweet.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", _tweet.username];
    self.timestampLabel.text = [self relativeDateStringForDate:_tweet.date];
}

- (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSDayCalendarUnit | NSWeekOfYearCalendarUnit |
    NSMonthCalendarUnit | NSYearCalendarUnit;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld y", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld mo", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld w", (long)components.weekOfYear];
    } else if (components.day > 0) {
        return [NSString stringWithFormat:@"%ld d", (long)components.day];
    } else {
        return [NSString stringWithFormat:@"%ld h", (long)components.hour];
    }
}

static NSInteger NameLabelMaxWidth = 218;
static NSInteger ActionViewHeight = 22;
static NSInteger NameLabelHeight = 16;
static NSInteger RetweetLabelHeight = 15 + 2;
static NSInteger CellVerticalPadding = 0;

+ (NSInteger)displayHeightForTweet:(Tweet *)tweet
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
    NSInteger tweetHeight = [tweet.text boundingRectWithSize:CGSizeMake(NameLabelMaxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    
    NSInteger height = tweetHeight + ActionViewHeight + NameLabelHeight + CellVerticalPadding;
    if (tweet.retweetCount > 0) {
        height += RetweetLabelHeight;
    }
    return height;
}

@end
