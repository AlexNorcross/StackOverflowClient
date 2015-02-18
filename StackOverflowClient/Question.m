//
//  Question.m
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/17/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "Question.h"

@implementation Question

+(NSArray *) questionsFromJSON: (NSData *)jsonData {
  NSError *parseError;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&parseError];
  if (parseError == nil) {
    NSArray *jsonArray = jsonDictionary[@"items"];
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in jsonArray) {
      Question *newQuestion = [[Question alloc] init];
      
      newQuestion.title = item[@"title"];
      
      NSDictionary *owner = item[@"owner"];
      NSString *urlString = owner[@"profile_image"];
      newQuestion.avatarURL = [NSURL URLWithString:urlString];
      
      [questions addObject:newQuestion];
    } //end for

    return [[NSArray alloc] initWithArray:questions];
    
  } else {
    NSLog(@"error parsing questions from JSON");
    return nil;
  } //end if
} //end func
@end
