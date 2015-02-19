//
//  StackOverflowService.h
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/17/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@interface StackOverflowService : NSObject

+(id) sharedService;

-(void) fetchQuestionsWithSearchTerm: (NSString *)searchTerm completionHandler:(void (^)(NSArray *results, NSString *error))completionHandler;

-(void) fetchAvatarImageFromURL: (NSURL *)imageURL completionHandler:(void (^)(UIImage *avatarImage))completionHandler;

-(void) fetchInformationForMe: (void (^)(User *myProfile, NSString *error))completionHandler;

@end
