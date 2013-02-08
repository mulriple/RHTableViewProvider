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
#import "ExampleFiveViewController.h"

@implementation ExamplesViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setTitle:@"Examples"];
  
  self.tableView = [RHTableViewProvider tableViewWithFrame:self.view.bounds style:UITableViewStylePlain forSuperView:self.view];
  self.provider = [[RHTableViewProviderEditable alloc] initWithTableView:_tableView delegate:self];
  
  [self.provider setContent:@[@"Grouped", @"Grouped Customized", @"Plain", @"Plain Customized", @"Editable"] withSections:NO];
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
    case 4:
    {
      ExampleFiveViewController *example = [[ExampleFiveViewController alloc] initWithNibName:nil bundle:nil];
      [[self navigationController] pushViewController:example animated:YES];
    }
      break;
  }
}

@end
