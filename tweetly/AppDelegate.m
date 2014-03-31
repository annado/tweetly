//
//  AppDelegate.m
//  tweetly
//
//  Created by Anna Do on 3/28/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterClient.h"
#import "SignInViewController.h"
#import "TimelineViewController.h"
#import "User.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:(85/255.0f) green:(172/255.0f) blue:(238/255.0f) alpha:1]];

    [self updateRootViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootViewController) name:UserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootViewController) name:UserDidLogoutNotification object:nil];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"tweetly"]) {
        if ([url.host isEqualToString:@"oauth"]) {
            [[TwitterClient instance] oAuthCallbackWithURL:url];
        }
        return YES;
    }
    return NO;
}

- (void)updateRootViewController
{
    if ([User currentUser] != nil) {
        TimelineViewController *timelineViewController = [[TimelineViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:timelineViewController];
        self.window.rootViewController = navigationController;
    } else {
        self.window.rootViewController = [[SignInViewController alloc] init];
    }
}

@end
