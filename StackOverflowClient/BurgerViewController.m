//
//  BurgerViewController.m
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/16/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "BurgerViewController.h"

@interface BurgerViewController ()

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UINavigationController *searchViewController;
@property (strong, nonatomic) UIButton *burgerButton;

@property (strong, nonatomic) UITapGestureRecognizer *tapToCloseBurgerOptions;
@property (strong, nonatomic) UIPanGestureRecognizer *slideForBurgerOptions;
@end

@implementation BurgerViewController

//Setup
- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Add search child view controller
  [self addChildViewController:self.searchViewController];
  self.searchViewController.view.frame = self.view.frame;
  [self.view addSubview:self.searchViewController.view];
  [self.searchViewController didMoveToParentViewController:self];
  
  self.topViewController = self.searchViewController;
  
  //Add burger button
  [self.burgerButton setImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
  [self.burgerButton addTarget:self action:@selector(pressedBurgerButton:) forControlEvents:UIControlEventTouchUpInside];
  [self.topViewController.view addSubview:self.burgerButton];
  
  //Slide gesture to display burger options
  self.slideForBurgerOptions = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideForBurgerOptions:)];
  [self.topViewController.view addGestureRecognizer:self.slideForBurgerOptions];
} //end func

#pragma mark - selectors

//Burger button
- (void) pressedBurgerButton:(id) sender {
  __weak BurgerViewController *weakSelf = self;
  
  self.burgerButton.userInteractionEnabled = false;
  
  [UIView animateWithDuration:0.5 animations:^{
    weakSelf.topViewController.view.center = CGPointMake(weakSelf.topViewController.view.center.x + 300, weakSelf.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    [weakSelf.topViewController.view addGestureRecognizer:weakSelf.tapToCloseBurgerOptions];
  }];
} //end func

//Slide gesture
- (void) slideForBurgerOptions:(id) sender {
  UIPanGestureRecognizer *slide = (UIPanGestureRecognizer *)sender;
  
  CGPoint pointTranslated = [slide translationInView:self.view];
  CGPoint velocity = [slide velocityInView:self.view];
  
  if (velocity.x > 0 || self.topViewController.view.frame.origin.x > 0) {
    self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + pointTranslated.x, self.topViewController.view.center.y);
    [slide setTranslation:CGPointZero inView:self.view];
  } //end if
  
  if (slide.state == UIGestureRecognizerStateEnded) {
    __weak BurgerViewController *weakSelf = self;
    if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 3) { //open
      self.burgerButton.userInteractionEnabled = false;
      [UIView animateWithDuration:0.2 animations:^{
        weakSelf.topViewController.view.center = CGPointMake(weakSelf.view.frame.size.width * 1.25, weakSelf.view.center.y);
      } completion:^(BOOL finished) {
        [weakSelf.view addGestureRecognizer:self.tapToCloseBurgerOptions];
      }];
    } else { //close
      [UIView animateWithDuration:0.2 animations:^{
        weakSelf.topViewController.view.center = self.view.center;
      } completion:^(BOOL finished) {
        [weakSelf.view removeGestureRecognizer:self.tapToCloseBurgerOptions];
      }];
    } //end if
  } //end if
} //end func

//Tap gesture
- (void) tapToCloseBurgerOptions:(id) sender {
  __weak BurgerViewController *weakSelf = self;
  
  [weakSelf.topViewController.view removeGestureRecognizer:weakSelf.tapToCloseBurgerOptions];
  
  [UIView animateWithDuration:0.5 animations:^{
    weakSelf.topViewController.view.center = weakSelf.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
  }];
} //end func

#pragma mark - lazy load properties

- (UINavigationController * ) searchViewController {
  if (_searchViewController == nil) {
    _searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_SEARCH"];
  } //end if
  return _searchViewController;
} //end func

- (UIButton *) burgerButton {
  if (_burgerButton == nil) {
    _burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 22, 40, 40)];
  } //end if
  return _burgerButton;
} //end func

- (UITapGestureRecognizer *) tapToCloseBurgerOptions {
  if (_tapToCloseBurgerOptions == nil) {
    _tapToCloseBurgerOptions = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseBurgerOptions:)];
  } //end if
  return _tapToCloseBurgerOptions;
} //end func
@end