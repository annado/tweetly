//
//  SignInViewController.m
//  tweetly
//
//  Created by Anna Do on 3/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "SignInViewController.h"
#import "TwitterClient.h"

@interface SignInViewController ()
- (IBAction)onSignInButton:(id)sender;

@end

@implementation SignInViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignInButton:(id)sender {
    NSLog(@"onSignInButton");
    [[TwitterClient instance] authorizeWithCallback:[NSURL URLWithString:@"tweetly://oauth"]
                                            success:^(BDBOAuthToken *accessToken, id responseObject) {
                                                NSLog(@"success!");
                                                NSLog(@"response: %@", responseObject);
                                            } failure:^(NSError *error) {
                                                NSLog(@"error: %@", error);
                                            }];

}
@end
