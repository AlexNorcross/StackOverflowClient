//
//  User.m
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/18/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *) parseMe: (NSData *) jsonData {
  NSError *parseError;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&parseError];
  if (parseError == nil) {
    NSArray *jsonArray = jsonDictionary[@"items"];
    NSDictionary *item = jsonArray[0];
    
    User *newUser = [[User alloc] init];
    
    newUser.displayName = item[@"display_name"];
    newUser.link = item[@"link"];
    
    NSString *urlString = item[@"profile_image"];
    newUser.avatarURL = [NSURL URLWithString:urlString];
    
    return newUser;
  } else {
    NSLog(@"error parsing me from JSON");
    return nil;
  } //end if
} //end func

@end
