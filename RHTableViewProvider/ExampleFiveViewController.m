//
//  ExampleFiveViewController.m
//  RHTableViewProvider
//
//  Created by Rob Hayward on 08/02/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "ExampleFiveViewController.h"

@implementation ExampleFiveViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Create a table view and add it to your view (Conveinience)
  self.tableView = [RHTableViewProvider tableViewWithFrame:self.view.bounds style:UITableViewStylePlain forSuperView:self.view];
  
  // Setup your table view provider
  self.provider = [[RHTableViewProviderEditable alloc] initWithTableView:_tableView delegate:self];
  
  // Update your content
  [_provider setContent:@[@"One", @"Two", @"Three"] withSections:NO];
}

#pragma mark - RHTableViewProviderDelegate

- (void)RHTableViewProvider:(RHTableViewProvider *)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  id object = [provider objectAtIndexPath:indexPath];
  NSLog(@"Hello Object: %@", object);
}

@end
