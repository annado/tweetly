//
//  MenuViewController.m
//  tweetly
//
//  Created by Anna Do on 4/4/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemCell.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController

static NSString *CellIdentifier = @"MenuItemCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Configure the nav buttons
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TwitterIcon"]];
        
        self.menuItems = @[
                           @{@"name": @"Profile", @"url":@"tweetly://profile"},
                           @{@"name": @"Timeline", @"url":@"tweetly://timeline"},
                           @{@"name": @"Mentions", @"url":@"tweetly://mentions"},
                           @{@"name": @"Log Out", @"url":@"tweetly://logout"}
                           ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
}

- (void)onHomeButton:(UIBarButtonItem *)button
{
    NSString *urlString = self.menuItems[1][@"url"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
}

#pragma mark TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCell *cell = (MenuItemCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = self.menuItems[indexPath.row][@"name"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString = self.menuItems[indexPath.row][@"url"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
}

@end
