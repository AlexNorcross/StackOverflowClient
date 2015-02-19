//
//  StackOverflowService.m
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/17/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "StackOverflowService.h"
#import "Question.h"
#import "User.h"

@implementation StackOverflowService

NSString *const key = @"mfcy*fFh6uRNCCRfel93jA((";

//Singleton
+(id) sharedService {
  static StackOverflowService *mySharedService = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mySharedService = [[self alloc] init];
  });
  return mySharedService;
} //end singleton

//Fetch questions
-(void) fetchQuestionsWithSearchTerm: (NSString *)searchTerm completionHandler:(void (^)(NSArray *results, NSString *error))completionHandler {
  //URL string - fetch by term
  NSString *urlString = @"https://api.stackexchange.com/2.2/";
  urlString = [urlString stringByAppendingString:@"search?order=desc&sort=activity&site=stackoverflow&intitle="];
  urlString = [urlString stringByAppendingString:searchTerm];
  //URL string - include token
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
  if (token != nil) {
    urlString = [urlString stringByAppendingString:@"&access_token="];
    urlString = [urlString stringByAppendingString:token];
    urlString = [urlString stringByAppendingString:@"&key="];
    urlString = [urlString stringByAppendingString:key];
  } //end if
  
  //URL request
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
  
  //Session
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error == nil) {
      NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
      switch (urlResponse.statusCode) {
        case 200 ... 299: {
          NSArray *results = [Question questionsFromJSON:data];
          
          dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(results, nil);
          });
          
          break;
        }
        default:
          completionHandler(nil, @"error fetching questions by search term; check URL status code");
          break;
      } //end switch
    } else {
      completionHandler(nil, @"error fetching questions by search term");
    } //end if
  }]; //end closure
  [dataTask resume];
} //end func

//Fetch avatar image
-(void) fetchAvatarImageFromURL:(NSURL *)imageURL completionHandler:(void (^)(UIImage *avatarImage))completionHandler {
  dispatch_queue_t quequeImage = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
  dispatch_async(quequeImage, ^{
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if (image != nil) {
        completionHandler(image);
      } else {
        completionHandler(nil);
      } //end if
    }); //end main thread
  }); //end image thread
} //end func

-(void) fetchInformationForMe: (void (^)(User *myProfile, NSString *error))completionHandler {
  //URL string - by user name
  NSString *urlString = @"https://api.stackexchange.com/2.2/me?order=desc&sort=reputation&site=stackoverflow";
  //URL - include token
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
  if (token != nil) {
    urlString = [urlString stringByAppendingString:@"&access_token="];
    urlString = [urlString stringByAppendingString:token];
    urlString = [urlString stringByAppendingString:@"&key="];
    urlString = [urlString stringByAppendingString:key];
  } //end if
  
  //URL
  NSURL *url = [[NSURL alloc] initWithString:urlString];
  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
  
  //Session
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error == nil) {
      NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *) response;
      switch (urlResponse.statusCode) {
        case 200 ... 299: {
          User *me = [User parseMe:data];
          dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(me, nil);
          });
          break;
        } //end case
        default:
          completionHandler(nil, @"error fetching user information; check URL status code");
          break;
      } //end switch
      
    } else {
      completionHandler(nil, @"error fetching user information");
    } //end if
  }];
  [dataTask resume];
} //end func
@end
