//
//  RHViewController.m
//  RHTableViewProvider
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "RHViewController.h"
#import "RHTableViewProvider.h"

@interface RHViewController ()

@property (strong, nonatomic) RHTableViewProvider *provider;

@end

@implementation RHViewController

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

- (void)RHTableViewProvider:(RHTableViewProvider *)provider tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  id object = [provider objectAtIndexPath:indexPath];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Selected" message:object delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}

- (NSString *)tableCellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row) {
    case 1:
      return @"CustomCell";
      break;
    default:
      return nil;
      break;
  }
}

- (NSString *)tableSectionHeaderViewClassForSection:(NSInteger)section
{
  return @"RHTableViewProviderSectionViewDefault";
}

- (NSString *)tableSectionFooterViewClassForSection:(NSInteger)section
{
  switch (section) {
    case 1:
      return @"RHTableViewProviderSectionViewDefault";
      break;
    
    default:
      return nil;
      break;
  }
}

@end
