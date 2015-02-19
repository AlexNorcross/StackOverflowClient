//
//  User.h
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/18/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User : NSObject

+(User *) parseMe: (NSData *) jsonData;

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) UIImage *avatarImage;

@end
