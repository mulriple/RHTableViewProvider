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
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.provider = [[RHTableViewProvider alloc] initWithTableView:self.tableView delegate:self];
  [[self view] addSubview:self.tableView];
}

- (void)fetchContent
{
  NSArray *content = [NSArray arrayWithObjects:@"One", @"Two", @"Three", nil];
  [self.provider setContent:content withSections:NO];
}

#pragma mark - RHTableViewProviderDelegate

- (void)RHTableViewProvider:(RHTableViewProvider *)provider tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  id object = [provider objectAtIndexPath:indexPath];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Selected" message:object delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}

- (NSString *)classNameForCellAtIndexPath:(NSIndexPath *)indexPath
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

@end
