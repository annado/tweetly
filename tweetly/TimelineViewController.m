//
//  TimelineViewController.m
//  tweetly
//
//  Created by Anna Do on 3/29/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "TimelineViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

static NSString *CellIdentifier = @"TweetCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tweetly";
        self.tweets = [[NSMutableArray alloc] init];
        [[TwitterClient instance] timelineWithSuccess:^(NSMutableArray *tweets) {
            self.tweets = [Tweet tweetsWithArray:tweets];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"Failed to get tweets");
        }];
        
        // Configure the nav buttons
        UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogOutButton:)];
        self.navigationItem.leftBarButtonItem = logOutButton;
        
        UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton:)];
        self.navigationItem.rightBarButtonItem = composeButton;
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

- (void)refresh
{
    NSLog(@"Reloading...");
    [self.refreshControl endRefreshing];
}

- (void)onLogOutButton:(UIBarButtonItem *)button
{
    NSLog(@"Log out");
    [[TwitterClient instance] logout];
}

- (void)onComposeButton:(UIBarButtonItem *)button
{
    NSLog(@"Compose");
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    composeViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:composeViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
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

@end
