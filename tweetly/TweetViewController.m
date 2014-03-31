//
//  TweetViewController.m
//  tweetly
//
//  Created by Anna Do on 3/30/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

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
    // Do any additional setup after loading the view from its nib.
}

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
    self.tweetLabel.text = _tweet.text;
}

@end
