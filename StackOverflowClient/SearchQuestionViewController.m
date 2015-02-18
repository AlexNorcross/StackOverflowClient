//
//  SearchQuestionViewController.m
//  StackOverflowClient
//
//  Created by Alexandra Norcross on 2/17/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "SearchQuestionViewController.h"
#import "QuestionTableViewCell.h"
#import "Question.h"
#import "StackOverflowService.h"

@interface SearchQuestionViewController () <UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableQuestions;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarQuestions;
@property (strong, nonatomic) NSArray *questions;
@end

@implementation SearchQuestionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Table
  self.tableQuestions.dataSource = self;
  self.tableQuestions.rowHeight = UITableViewAutomaticDimension;
  
  //Search bar
  self.searchBarQuestions.delegate = self;
} //end func

#pragma mark - table view data source

//Cell count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
} //end func

//Cell content
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //Cell/Question
  QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_SEARCH_QUESTION" forIndexPath:indexPath];
  Question *question = self.questions[indexPath.row];
  //Cell content
  cell.imageViewAvatar.image = nil;
  [[StackOverflowService sharedService] fetchAvatarImageFromURL:question.avatarURL completionHandler:^(UIImage *avatarImage) {
    cell.imageViewAvatar.image = avatarImage;
    cell.imageViewAvatar.layer.cornerRadius = 5;
    cell.imageViewAvatar.layer.masksToBounds = true;
  }];
  cell.textViewQuestion.text = question.title;
  [cell.textViewQuestion setFont:[UIFont fontWithName:@"HiraMinProN-W3" size:17]];
  //Return cell.
  return cell;
} //end func

#pragma mark - search bar delegate

//Search
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [[StackOverflowService sharedService] fetchQuestionsWithSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSString *error) {
    self.questions = results;
    [self.tableQuestions reloadData];
    if (error != nil) {
      NSLog(@"%@", error);
    } //end if
  }];
} //end func
@end
