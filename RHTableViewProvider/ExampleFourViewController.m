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
  
  self.tableView = [RHTableViewProvider tableViewWithFrame:self.view.bounds style:UITableViewStylePlain forSuperView:self.view];
  self.provider = [[RHTableViewProvider alloc] initWithTableView:_tableView delegate:self];
  
  [_provider setShouldDrawCustomViews:YES];
  [_provider setDefaultCellClassName:@"ExampleFourCell"];
  
  NSDictionary *sectionA = @{ RHTableViewProviderSectionRows:@[@"One", @"Two", @"Three"], RHTableViewProviderSectionHeader:@"Section A" };
  NSDictionary *sectionB = @{ RHTableViewProviderSectionRows:@[@"One", @"Two", @"Three"], RHTableViewProviderSectionHeader:@"Section B", RHTableViewProviderSectionFooter:@"Section B Footer" };
  
  [self.provider setContent:@[sectionA, sectionB] withSections:YES];
}

#pragma mark - RHTableViewProviderDelegate

- (void)RHTableViewProvider:(RHTableViewProvider *)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  id object = [provider objectAtIndexPath:indexPath];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Selected" message:object delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}

@end
