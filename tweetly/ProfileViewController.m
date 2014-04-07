//
//  ProfileViewController.m
//  tweetly
//
//  Created by Anna Do on 4/5/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <ColorUtils/ColorUtils.h>
#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import "User.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *timelineView;
@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton:)];
        self.navigationItem.rightBarButtonItem = composeButton;
    }
    return self;
}

- (id)initWithUser:(User *)user
{
    self = [super init];
    if (self) {
        _user = user;
        self.title = (_user == [User currentUser]) ? @"Me" : @"Profile";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.backgroundImageView setImageWithURL:_user.backgroundURL];
    [self.profileImageView setImageWithURL:_user.avatarURL];
    // add rounded corners
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    [self.profileImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.profileImageView.layer setBorderWidth: 2.0];
    
    self.nameLabel.text = _user.name;
    self.usernameLabel.text = _user.username;

    UIColor *textColor = [UIColor colorWithString:_user.textHexColor];
    self.nameLabel.textColor = textColor;
    self.usernameLabel.textColor = textColor;
    self.numTweetsLabel.text = [@(_user.tweetCount) stringValue];
    self.numFollowersLabel.text = [@(_user.followerCount) stringValue];
    self.numFollowingLabel.text = [@(_user.followingCount) stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onComposeButton:(UIBarButtonItem *)buttonItem
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowComposerNotification object:@{@"replyTweet": @""}];
}

@end
