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

@interface ApplicationViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) UINavigationController *timelineNavController;
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

        self.timelineNavController = navigationController;
        [self addChildViewController:self.timelineNavController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *mainView = self.timelineNavController.view;
    UIView *menuView = self.menuViewController.view;
//    self.menuView = menuView;
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
            [UIView animateWithDuration:0.5
                             animations:^{
                                 NSInteger minWidthMult = 1;
                                 if (velocity.x < 0) {
                                     minWidthMult = 3;
                                 }
                                 
                                 if (point.x > (minWidthMult * frame.size.width/4)) {
                                     CGRect frame = self.contentView.frame;
                                     frame.origin.x = frame.size.width - frame.size.width/6;
                                     self.contentView.frame = frame;
                                 } else {
                                     CGRect frame = self.contentView.frame;
                                     frame.origin.x = 0;
                                     self.contentView.frame = frame;
                                 }
                             }
                             completion:^(BOOL finished){ if(finished) {
                self.panning = NO;
            }
                             }];
        }

    }
}

@end
