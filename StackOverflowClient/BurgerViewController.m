//
//  BurgerViewController.m
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/16/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "BurgerViewController.h"
#import "MenuTableViewController.h"
#import "ProfileViewController.h"
#import "QuestionsViewController.h"
#import "MenuTableRows.h"

@interface BurgerViewController ()

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UINavigationController *searchViewController;
@property (strong, nonatomic) ProfileViewController *profileViewController;
@property (strong, nonatomic) QuestionsViewController *questionsViewController;
@property (nonatomic) NSInteger selectedRow;

@property (strong, nonatomic) UIButton *burgerButton;

@property (strong, nonatomic) UITapGestureRecognizer *tapToCloseBurgerOptions;
@property (strong, nonatomic) UIPanGestureRecognizer *slideForBurgerOptions;

@end

@implementation BurgerViewController

NSInteger const slideRightBuffer = 300;
float const durationForShortAnimation = 0.2;
float const durationForLongAnimation = 0.5;

//Setup
- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Add child view controller
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

#pragma mark - functions

- (void) switchViewController:(UIViewController *)destinationViewController {

  __weak BurgerViewController *weakSelf = self;
  [UIView animateWithDuration:durationForShortAnimation animations:^{
    //Hide top controller
    weakSelf.topViewController.view.frame = CGRectMake(weakSelf.view.frame.size.width, weakSelf.view.frame.origin.y, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
  } completion:^(BOOL finished) {
    //New top controller view frame
    destinationViewController.view.frame = weakSelf.topViewController.view.frame;
    
    //Remove old top controller
    [weakSelf.burgerButton removeFromSuperview];
    [weakSelf.topViewController.view removeGestureRecognizer:self.slideForBurgerOptions];
    [weakSelf.topViewController willMoveToParentViewController:nil];
    [weakSelf.topViewController.view removeFromSuperview];
    [weakSelf.topViewController removeFromParentViewController];
    
    //Set new top controller
    weakSelf.topViewController = destinationViewController;
    
    [weakSelf addChildViewController:weakSelf.topViewController];
    [weakSelf.view addSubview:weakSelf.topViewController.view];
    [weakSelf.topViewController didMoveToParentViewController:weakSelf];
    [weakSelf.topViewController.view addSubview:weakSelf.burgerButton];
    [weakSelf.topViewController.view addGestureRecognizer:weakSelf.slideForBurgerOptions];
  
    //Show top controller
    [weakSelf closeBurgerOptions];
  }];
} //end func

#pragma mark - selectors

//Burger button
- (void) pressedBurgerButton:(id) sender {
  __weak BurgerViewController *weakSelf = self;
  
  self.burgerButton.userInteractionEnabled = false;
  
  [UIView animateWithDuration:durationForLongAnimation animations:^{
    weakSelf.topViewController.view.center = CGPointMake(weakSelf.topViewController.view.center.x + slideRightBuffer, weakSelf.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    [weakSelf.topViewController.view addGestureRecognizer:weakSelf.tapToCloseBurgerOptions];
  }];
} //end func

//Slide gesture
- (void) slideForBurgerOptions:(id) sender {
  UIPanGestureRecognizer *slide = (UIPanGestureRecognizer *)sender;
  
  CGPoint pointTranslated = [slide translationInView:self.view];
  CGPoint velocity = [slide velocityInView:self.view];
  
  //Slide top view controller
  if (velocity.x > 0 || self.topViewController.view.frame.origin.x > 0) {
    self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + pointTranslated.x, self.topViewController.view.center.y);
    [slide setTranslation:CGPointZero inView:self.view];
  } //end if
  
  //Open/Close top view controller
  if (slide.state == UIGestureRecognizerStateEnded) {
    __weak BurgerViewController *weakSelf = self;
    if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 3) { //open
      self.burgerButton.userInteractionEnabled = false;
      [UIView animateWithDuration:durationForShortAnimation animations:^{
        weakSelf.topViewController.view.center = CGPointMake(weakSelf.view.frame.size.width * 1.25, weakSelf.view.center.y);
      } completion:^(BOOL finished) {
        [weakSelf.topViewController.view addGestureRecognizer:self.tapToCloseBurgerOptions];
      }];
    } else { //close
      [UIView animateWithDuration:durationForShortAnimation animations:^{
        weakSelf.topViewController.view.center = self.view.center;
      } completion:^(BOOL finished) {
        [weakSelf.topViewController.view removeGestureRecognizer:self.tapToCloseBurgerOptions];
      }];
    } //end if
  } //end if
} //end func

//Tap gesture
- (void) closeBurgerOptions {
  __weak BurgerViewController *weakSelf = self;
  
  [weakSelf.topViewController.view removeGestureRecognizer:weakSelf.tapToCloseBurgerOptions];
  
  [UIView animateWithDuration:durationForLongAnimation animations:^{
    weakSelf.topViewController.view.center = weakSelf.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
  }];
} //end func

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  MenuTableViewController *destinationViewController = segue.destinationViewController;
  destinationViewController.changeTopViewController = ^(NSInteger row) {
    if (self.selectedRow == row) {
      [self closeBurgerOptions];
    } else {
      UIViewController *destinationVC;
      switch (row) {
        case rowSearch: {
          destinationVC = self.searchViewController;
          break;
        } //end case
        case rowMyQuestions: {
          destinationVC = self.questionsViewController;
          break;
        } //end case
        case rowMyProfile: {
          destinationVC = self.profileViewController;
          break;
        } //end case
        default:
          break;
      } //end switch
      self.selectedRow = row;
      [self switchViewController:destinationVC];
    } //end if
  }; //end block
} //end func

#pragma mark - lazy load properties

- (UINavigationController *) searchViewController {
  if (_searchViewController == nil) {
    _searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_SEARCH"];
  } //end if
  return _searchViewController;
} //end func

- (ProfileViewController *) profileViewController {
  if (_profileViewController == nil) {
    _profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_PROFILE"];
  } //end if
  return _profileViewController;
} //end func

- (QuestionsViewController *) questionsViewController {
  if (_questionsViewController == nil) {
    _questionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_QUESTIONS"];
  } //end if
  return _questionsViewController;
} //end func

- (UIButton *) burgerButton {
  if (_burgerButton == nil) {
    _burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 22, 40, 40)];
  } //end if
  return _burgerButton;
} //end func

- (UITapGestureRecognizer *) tapToCloseBurgerOptions {
  if (_tapToCloseBurgerOptions == nil) {
    _tapToCloseBurgerOptions = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBurgerOptions)];
  } //end if
  return _tapToCloseBurgerOptions;
} //end func
@end