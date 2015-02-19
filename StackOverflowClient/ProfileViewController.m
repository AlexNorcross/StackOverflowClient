//
//  ProfileViewController.m
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/18/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "ProfileViewController.h"
#import "StackOverflowService.h"
#import "User.h"

@interface ProfileViewController ()

@property (assign, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (assign, nonatomic) IBOutlet UILabel *labelDisplayName;
@property (assign, nonatomic) IBOutlet UILabel *labelLink;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Me
  [[StackOverflowService sharedService] fetchInformationForMe:^(User *myProfile, NSString *error) {
    if (error == nil) {
      [[StackOverflowService sharedService] fetchAvatarImageFromURL:myProfile.avatarURL completionHandler:^(UIImage *avatarImage) {
        self.imageViewAvatar.image = avatarImage;
      }];
      self.labelDisplayName.text = myProfile.displayName;
      self.labelLink.text = myProfile.link;
    } else {
      NSLog(@"%@", error);
    } //end if
  }]; //end block
} //end func
@end
