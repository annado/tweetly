//
//  ComposeViewController.m
//  tweetly
//
//  Created by Anna Do on 3/30/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "User.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *composerTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Configure the nav buttons
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet:)];
        self.navigationItem.rightBarButtonItem = submitButton;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUserProfile];
    self.composerTextView.delegate = self;
}

- (void)onCancel:(UIBarButtonItem *)button
{
    [self.delegate composeViewController:self postedTweet:nil];
}

- (void)onTweetSuccess:(Tweet *)tweet
{
    [self.delegate composeViewController:self postedTweet:tweet];
}

- (void)onTweet:(UIBarButtonItem *)button
{
    NSString *text = self.composerTextView.text;
    if (text.length > 0) {
        [[TwitterClient instance] postTweet:text success:^(Tweet *tweet) {
            NSLog(@"Success!:");
            [self onTweetSuccess:tweet];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)setupUserProfile
{
    User *user = [User currentUser];
    self.nameLabel.text = user.name;
    self.usernameLabel.text = user.username;
    [self.avatarImageView setImageWithURL:user.avatarURL];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = ([textView.text length] > 0);
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = ([textView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = ([textView.text length] > 0);
}

@end
