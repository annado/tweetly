//
//  TimelineViewController.m
//  tweetly
//
//  Created by Anna Do on 3/29/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "TimelineViewController.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

NSString * const ShowComposerNotification = @"ShowComposerNotification";

@implementation TimelineViewController

static NSString *CellIdentifier = @"TweetCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Timeline";
        self.tweets = [[NSMutableArray alloc] init];
        [self loadTweets];
        
        // Configure the nav buttons
        UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogOutButton:)];
        self.navigationItem.leftBarButtonItem = logOutButton;
        
        UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton:)];
        self.navigationItem.rightBarButtonItem = composeButton;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onComposeNotification:) name:ShowComposerNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self addRefreshControl];
}

- (void)addRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
}

- (void)loadTweets
{
    [self.refreshControl beginRefreshing];
    [[TwitterClient instance] timelineWithSuccess:^(NSMutableArray *tweets) {
        self.tweets = [Tweet tweetsWithArray:tweets];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get tweets");
        [self.refreshControl endRefreshing];
    }];
}

- (void)refresh
{
    [self loadTweets];
}

- (void)onLogOutButton:(UIBarButtonItem *)button
{
    [[TwitterClient instance] logout];
}

- (void)onComposeButton:(UIBarButtonItem *)button
{
    [self showComposer:nil];
}

- (void)showComposer:(Tweet *)replyTweet
{
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    composeViewController.delegate = self;
    composeViewController.replyTweet = replyTweet;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:composeViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}

- (void)onComposeNotification:(NSNotification *)notification
{
    Tweet *replyTweet = notification.object[@"replyTweet"];
    [self showComposer:replyTweet];
}

- (void)onViewTweet:(Tweet *)tweet
{
    TweetViewController *tweetViewController = [[TweetViewController alloc] init];
    tweetViewController.tweet = tweet;
    [self.navigationController pushViewController:tweetViewController animated:YES];
}

#pragma mark ComposeView delegate methods
- (void)composeViewController:(ComposeViewController *)composeViewController
                  postedTweet:(Tweet *)tweet
{
    if (tweet != nil) {
        [self.tweets insertObject:tweet atIndex:0];
        [self.tableView reloadData];
    } else {
        
    }
    [self dismissViewControllerAnimated:YES completion: nil];
}

#pragma mark TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = (TweetCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = self.tweets[indexPath.row];
    return [TweetCell displayHeightForTweet:tweet];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = self.tweets[indexPath.row];
    [self onViewTweet:tweet];
}
@end
