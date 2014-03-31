//
//  ComposeViewController.m
//  tweetly
//
//  Created by Anna Do on 3/30/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ComposeViewController.h"
#import "User.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *composerTextView;
@end

@implementation ComposeViewController

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
    [self setupUserProfile];
}

- (void)setupUserProfile
{
    User *user = [User currentUser];
    self.nameLabel.text = user.name;
    self.usernameLabel.text = user.username;
    [self.avatarImageView setImageWithURL:user.avatarURL];
}

@end
