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
@property (nonatomic, strong) UINavigationController *profileViewController;
@property (nonatomic, assign) NSInteger startingX;
@property (nonatomic, assign) BOOL panning;
@end

@implementation ApplicationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init Menu view
        _menuViewController = [[MenuViewController alloc] init];
        
        // init Timeline/Profile view
        _timelineViewController = [[TimelineViewController alloc] init];
        _timelineNavController = [[UINavigationController alloc]
                                                        initWithRootViewController:_timelineViewController];

        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithUser:[User currentUser]];
        _profileViewController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        
        [self addChildViewController:_timelineNavController];
        [self addChildViewController:_profileViewController];
    }
    return self;
}

- (void)openURL:(NSURL *)url
{
    NSDictionary *parameters = [NSDictionary dictionaryFromQueryString:url.query];
    
    [self closeMenu];
    if ([url.host isEqualToString:@"timeline"]) {
        _timelineViewController.mentions = NO;
        [_contentView bringSubviewToFront:_timelineNavController.view];
    } else if ([url.host isEqualToString:@"mentions"]) {
        _timelineViewController.mentions = YES;
        [_contentView bringSubviewToFront:_timelineNavController.view];
    } else if ([url.host isEqualToString:@"profile"]) {
        NSLog(@"profiles link");
        if (parameters[@"user"]) {
            NSLog(@"profile for user: %@", parameters[@"user"]);
        } else {
            NSLog(@"profile for currentUser");
            [_contentView bringSubviewToFront:_profileViewController.view];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // init Menu
    UINavigationController *menuNavController = [[UINavigationController alloc] initWithRootViewController:_menuViewController];
    UIView *menuView = menuNavController.view;
    [self addChildViewController:menuNavController];

    CGRect frame = menuView.frame;
    frame.size.width = frame.size.width - frame.size.width/6;
    menuView.frame = frame;

    UIView *mainView = _timelineNavController.view;
    [_contentView addSubview:_profileViewController.view];
    [self.view addSubview:menuView];
    [_contentView addSubview:mainView];
    [self.view bringSubviewToFront:_contentView];
    [_contentView bringSubviewToFront:_timelineNavController.view];
    
    // set drop shadow
    [_contentView.layer setCornerRadius:3];
    [_contentView.layer setShadowColor:[UIColor grayColor].CGColor];
    [_contentView.layer setShadowOpacity:0.8];
    [_contentView.layer setShadowOffset:CGSizeMake(-2, -2)];

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
    
    CGRect frame = _contentView.frame;

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _panning = (point.x > 0 && point.x - frame.origin.x < frame.size.width/4);
        self.startingX = point.x;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (_panning && point.x > 0) {
            frame.origin.x = point.x - self.startingX;
            if (frame.origin.x > 0) {
                _contentView.frame = frame;
            }
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (_panning) {
            _panning = NO;

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
    CGRect frame = _contentView.frame;
    if (frame.origin.x == 0) {
        return;
    }
    
    frame.origin.x = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         _contentView.frame = frame;
                     }
                     completion:nil];

}

- (void)openMenu
{
    CGRect frame = _contentView.frame;
    frame.origin.x = frame.size.width - frame.size.width/6;
    _contentView.frame = frame;

    [UIView animateWithDuration:0.5
                     animations:^{
                         _contentView.frame = frame;
                     }
                     completion:nil];

}

@end
