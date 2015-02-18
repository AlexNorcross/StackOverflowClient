//
//  QuestionTableViewCell.h
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/17/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (weak, nonatomic) IBOutlet UITextView *textViewQuestion;
@end
