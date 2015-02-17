//
//  WebOAuthViewController.m
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/16/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "WebOAuthViewController.h"

@interface WebOAuthViewController () <WKNavigationDelegate>

@end

@implementation WebOAuthViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:webView];
  webView.navigationDelegate = self;
  
  NSURL *urlStack = [NSURL URLWithString:@"https://stackexchange.com/oauth/dialog?client_id=4289&scope=no_expiry&redirect_uri=https://stackexchange.com/oauth/login_success"];
  [webView loadRequest:[NSURLRequest requestWithURL:urlStack]];
} //end func

#pragma mark - web navigation delegate

- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

  NSURLRequest *currentRequest = navigationAction.request;
  NSURL *currentURL = currentRequest.URL;
  
  if ([currentURL.description containsString:@"access_token"]) {
    //Token
    NSArray *stringComponents = [currentURL.description componentsSeparatedByString:@"="];
    NSString *token = stringComponents.lastObject;
    
    //Save
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:true completion:nil];
  } //end if
  
  decisionHandler(WKNavigationActionPolicyAllow);
} //end func
@end
