//
//  ProfileViewController.m
//  tweetly
//
//  Created by Anna Do on 4/5/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <ColorUtils/ColorUtils.h>
#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import "TimelineViewController.h"
#import "ProfileBannerView.h"
#import "User.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;
@property (weak, nonatomic) IBOutlet UIView *timelineView;
@property (weak, nonatomic) IBOutlet ProfileBannerView *bannerView;
@property (nonatomic, strong) TimelineViewController *timelineViewController;
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
        self.timelineViewController = [[TimelineViewController alloc] initWithUser:_user];
        [self addChildViewController:self.timelineViewController];
        self.title = (_user == [User currentUser]) ? @"Me" : @"Profile";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.bannerView.user = _user;
    [self.view addSubview:self.bannerView];
    
    self.timelineView = self.timelineViewController.view;
    CGRect frame = self.timelineView.frame;
    frame.origin.y = 306;
    frame.size.height = 262;
    self.timelineView.frame = frame;
    [self.view addSubview:self.timelineView];
    
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
