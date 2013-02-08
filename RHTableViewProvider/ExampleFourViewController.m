//
//  ExampleFourViewController.m
//  RHTableViewProvider
//
//  Created by Rob Hayward on 07/02/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "ExampleFourViewController.h"

@implementation ExampleFourViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupTableView];
  [self fetchContentWithSections];
}

- (void)setupTableView
{
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.provider = [[RHTableViewProvider alloc] initWithTableView:self.tableView delegate:self];
  [_provider setShouldDrawCustomViews:YES];
  [_provider setDefaultCellClassName:@"ExampleFourCell"];
  [[self view] addSubview:self.tableView];
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

@end
