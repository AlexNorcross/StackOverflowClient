//
//  MenuTableViewController.m
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/16/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "MenuTableViewController.h"
#import "WebOAuthViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void) viewDidLoad {
  [super viewDidLoad];
} //end func

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
  if (token == nil) {
    WebOAuthViewController *webViewController = [[WebOAuthViewController alloc] init];
    [self presentViewController:webViewController animated:true completion:^{
    }];
  } //end if
} //end func
@end
