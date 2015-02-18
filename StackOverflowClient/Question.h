//
//  Question.h
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/17/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Question : NSObject

+(NSArray *) questionsFromJSON: (NSData *)jsonData;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) UIImage *avatarImage;

@end
