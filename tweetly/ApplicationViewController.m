//
//  ApplicationViewController.m
//  tweetly
//
//  Created by Anna Do on 4/4/14.
//  Copyright (c) 2014 Anna Do. All rights reserved.
//

#import "ApplicationViewController.h"
#import "MenuViewController.h"
#import "TimelineViewController.h"
#import "ProfileViewController.h"
#import "NSDictionary+BDBOAuth1Manager.h"
#import "User.h"

@interface ApplicationViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) UINavigationController *timelineNavController;
@property (nonatomic, strong) TimelineViewController *timelineViewController;
@property (nonatomic, strong) ProfileViewController *profileViewController;
@property (nonatomic, assign) NSInteger startingX;
@property (nonatomic, assign) BOOL panning;
@end

@implementation ApplicationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init Menu view
        self.menuViewController = [[MenuViewController alloc] init];
        [self addChildViewController:self.menuViewController];
        
        
        // init Timeline view
        TimelineViewController *timelineViewController = [[TimelineViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:timelineViewController];

        self.timelineViewController = timelineViewController;
        self.timelineNavController = navigationController;
        self.profileViewController = [[ProfileViewController alloc] initWithUser:[User currentUser]];
        [self addChildViewController:self.timelineNavController];
        [self addChildViewController:self.profileViewController];
    }
    return self;
}

- (void)openURL:(NSURL *)url
{
    NSDictionary *parameters = [NSDictionary dictionaryFromQueryString:url.query];
    
    [self closeMenu];
    if ([url.host isEqualToString:@"timeline"]) {
        self.timelineViewController.mentions = NO;
        [self.view bringSubviewToFront:self.contentView];
    } else if ([url.host isEqualToString:@"mentions"]) {
        self.timelineViewController.mentions = YES;
        [self.view bringSubviewToFront:self.contentView];
    } else if ([url.host isEqualToString:@"profile"]) {
        NSLog(@"profiles link");
        if (parameters[@"user"]) {
            NSLog(@"profile for user: %@", parameters[@"user"]);
        } else {
            NSLog(@"profile for currentUser");
            [self.view bringSubviewToFront:self.profileViewController.view];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *mainView = self.timelineNavController.view;
    UIView *menuView = self.menuViewController.view;
    [self.view addSubview:self.profileViewController.view];
    [self.view addSubview:menuView];
    [self.contentView addSubview:mainView];
    [self.view bringSubviewToFront:self.contentView];

    // Gesture recognizer
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    CGRect frame = self.contentView.frame;

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
        self.panning = (point.x > 0 && point.x - frame.origin.x < frame.size.width/4);
        self.startingX = point.x;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (point.x > 0 && self.panning) {
            frame.origin.x = point.x - self.startingX;
            self.contentView.frame = frame;
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
        if (self.panning) {
            self.panning = NO;

            NSInteger minWidthMult = 1;
            if (velocity.x < 0) { // panning to the left
                minWidthMult = 3;
            }
            
            if (point.x > (minWidthMult * frame.size.width/4)) {
                [self openMenu];
            } else {
                [self closeMenu];
            }
        }

    }
}

- (void)closeMenu
{
    CGRect frame = self.contentView.frame;
    if (frame.origin.x == 0) {
        return;
    }
    
    frame.origin.x = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.contentView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                             self.panning = NO;
                         }
                     }];

}

- (void)openMenu
{
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width - frame.size.width/6;
    self.contentView.frame = frame;

    [UIView animateWithDuration:0.5
                     animations:^{
                         self.contentView.frame = frame;
                     }
                     completion:nil];

}

@end
