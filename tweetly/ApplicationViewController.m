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
@property (nonatomic, strong) UINavigationController *navController;
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

        self.navController = navigationController;
        [self addChildViewController:self.navController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *mainView = self.navController.view;
    UIView *menuView = self.menuViewController.view;
    [self.contentView addSubview:menuView];
    [self.contentView addSubview:mainView];
    [self.contentView bringSubviewToFront:mainView];

    // Gesture recognizer
    UIScreenEdgePanGestureRecognizer *panGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    panGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onPan:(UIScreenEdgePanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer locationInView:self.contentView];
//    CGPoint velocity = [panGestureRecognizer velocityInView:self.contentView];
    
    CGRect frame = self.navController.view.frame;

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
        frame.origin.x = point.x;
        self.navController.view.frame = frame;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));

        [UIView animateWithDuration:0.5
                         animations:^{
                             if (point.x > (frame.size.width/3)) {
                                 CGRect frame = self.navController.view.frame;
                                 frame.origin.x = frame.size.width - frame.size.width/6;
                                 self.navController.view.frame = frame;
                             } else {
                                 CGRect frame = self.navController.view.frame;
                                 frame.origin.x = 0;
                                 self.navController.view.frame = frame;
                             }
                         }
                         completion:^(BOOL finished){ if(finished) {}
                         }];
    }
}

@end
