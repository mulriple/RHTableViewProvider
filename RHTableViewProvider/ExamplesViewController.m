//
//  ExamplesViewController.m
//  RHTableViewProvider
//
//  Created by Rob Hayward on 07/02/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "ExamplesViewController.h"
#import "ExampleOneViewController.h"
#import "ExampleTwoViewController.h"
#import "ExampleThreeViewController.h"
#import "ExampleFourViewController.h"

@implementation ExamplesViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setTitle:@"Examples"];
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
  NSArray *content = [NSArray arrayWithObjects:@"Grouped", @"Grouped Customized", @"Plain", @"Plain Customized", nil];
  [self.provider setContent:content withSections:NO];
}

#pragma mark - RHTableViewProviderDelegate

- (void)RHTableViewProvider:(RHTableViewProvider *)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
    case 0:
    {
      ExampleOneViewController *example = [[ExampleOneViewController alloc] initWithNibName:nil bundle:nil];
      [[self navigationController] pushViewController:example animated:YES];
    }
      break;
    case 1:
    {
      ExampleTwoViewController *example = [[ExampleTwoViewController alloc] initWithNibName:nil bundle:nil];
      [[self navigationController] pushViewController:example animated:YES];
    }
      break;
    case 2:
    {
      ExampleThreeViewController *example = [[ExampleThreeViewController alloc] initWithNibName:nil bundle:nil];
      [[self navigationController] pushViewController:example animated:YES];
    }
      break;
    case 3:
    {
      ExampleFourViewController *example = [[ExampleFourViewController alloc] initWithNibName:nil bundle:nil];
      [[self navigationController] pushViewController:example animated:YES];
    }
      break;
  }
}

- (NSString *)tableCellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

@end
