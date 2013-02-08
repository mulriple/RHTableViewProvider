//
//  ExampleTwoViewController.m
//  RHTableViewProvider
//
//  Created by Rob Hayward on 07/02/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "ExampleTwoViewController.h"

@implementation ExampleTwoViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupTableView];
  [self fetchContent];
}

- (void)setupTableView
{
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.provider = [[RHTableViewProvider alloc] initWithTableView:self.tableView delegate:self];
  
  [[self view] addSubview:self.tableView];
}

- (void)fetchContent
{
  NSArray *content = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", nil];
  NSDictionary *section = [NSDictionary dictionaryWithObjectsAndKeys:content, RHTableViewProviderSectionRows, @"Section Name", RHTableViewProviderSectionHeader, nil];
  [self.provider setContent:[NSArray arrayWithObject:section] withSections:YES];
}

- (void)fetchContentWithSections
{
  NSArray *contentA = [NSArray arrayWithObjects:@"One", @"Two", @"Three", nil];
  NSArray *contentB = [NSArray arrayWithObjects:@"Four", @"Five", @"Six", nil];
  NSDictionary *sectionA = [NSDictionary dictionaryWithObjectsAndKeys:contentA, RHTableViewProviderSectionRows, @"Section A", RHTableViewProviderSectionHeader, nil];
  NSDictionary *sectionB = [NSDictionary dictionaryWithObjectsAndKeys:contentB, RHTableViewProviderSectionRows, @"Section B", RHTableViewProviderSectionHeader, @"Section B Footer", RHTableViewProviderSectionFooter, nil];
  [self.provider setContent:[NSArray arrayWithObjects:sectionA, sectionB, nil] withSections:YES];
}

#pragma mark - RHTableViewProviderDelegate

- (void)RHTableViewProvider:(RHTableViewProvider *)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  id object = [provider objectAtIndexPath:indexPath];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Selected" message:object delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}

- (NSString *)tableCellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return @"ExampleTwoCell";
}

@end
