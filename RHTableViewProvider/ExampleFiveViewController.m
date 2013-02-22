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
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTableAction:)];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if (!self.tableView)
  {
    self.tableView = [RHTableViewProvider tableViewWithFrame:self.view.bounds style:UITableViewStylePlain forSuperView:self.view];
    self.provider = [[RHTableViewProvider alloc] initWithTableView:_tableView delegate:self customise:NO];
    [_provider setContent:@[@"One", @"Two", @"Three"] withSections:NO];
  }
}

#pragma mark - Actions

- (void)editTableAction:(id)sender
{
  if ([_tableView isEditing])
  {
    [_tableView setEditing:NO animated:NO];  
  }
  else
  {
    [_tableView setEditing:YES animated:YES];
  }
}

#pragma mark - RHTableViewProviderDelegate

- (void)RHTableViewProvider:(RHTableViewProvider *)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  id object = [provider objectAtIndexPath:indexPath];
  NSLog(@"Hello Object: %@", object);
}

@end
