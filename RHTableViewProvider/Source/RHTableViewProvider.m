//
//  RHTableProvider.m
//  RHKit
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "RHTableViewProvider.h"
#import "RHTableViewProviderCell.h"
#import "RHTableViewProviderRefreshView.h"

#define PULL_TO_REFRESH_DISTANCE 70.0f
#define PULL_TO_REFRESH_TIMEOUT 10.0f

NSString *const RHTableViewProviderSectionName = @"RHTableViewProviderSectionName";
NSString *const RHTableViewProviderSectionRows = @"RHTableViewProviderSectionRows";

@implementation RHTableViewProvider

- (id)initWithTableView:(UITableView *)aTableView delegate:(id<RHTableViewProviderDelegate>)aDelegate
{
  self = [super init];
  if (self) {
    self.tableView = aTableView;
    self.delegate = aDelegate;
    [self setup];
  }
  return self;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
  id object = nil;
  
  NSDictionary *section = [self.content objectAtIndex:indexPath.section];
  NSArray *rows = [section valueForKey:RHTableViewProviderSectionRows];
  object = [rows objectAtIndex:indexPath.row];
  
  return object;
}

#pragma mark - Setters

- (void)setContent:(NSArray *)theContent withSections:(BOOL)sections
{  
  _hasSections = sections;
  
  if (theContent == nil) {
    theContent = [[NSArray alloc] init];
  }
  
  if (_hasSections) {
    self.content = theContent;
  } else {
    self.content = [self contentWithSections:theContent];
  }
  
  [self reload];
}

- (void)updateTotalItems
{
  _totalItems = 0;
  
  for (NSDictionary *section in self.content) {
    _totalItems += [[section valueForKey:RHTableViewProviderSectionRows] count];
  }
}

- (BOOL)hasContent {
  
  if (self.content == nil) {
    return NO;
  }
  
  if ([self.content count] < 1) {
    return NO;
  }
  
  return YES;
}

#pragma mark - Reload

- (void)reload
{  
  BOOL hasContent = [self hasContent];
  if (hasContent) {
    [self displayWithData];
    [self updateTotalItems];
    [self.tableView reloadData];
  } else {
    [self displayWithoutData];
  }
}

- (void)reloadVisibleCells
{
  NSArray *visibleCells = self.tableView.visibleCells;
  for (RHTableViewProviderCell *cell in visibleCells) {
    
    id object = [self objectAtIndexPath:cell.indexPath];
    [cell populateWithObject:object];
  }
}

#pragma mark - Display State

- (void)displayWithData
{
  [self.emptyView setHidden:YES];
  [self.tableView setHidden:NO];
}

- (void)displayWithoutData
{
  [self.tableView setHidden:YES];
  [self.emptyView setHidden:NO];
}

- (NSArray *)contentWithSections:(NSArray *)theContent
{  
  NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:0];
  
  NSMutableDictionary *section = [NSMutableDictionary dictionaryWithCapacity:0];
  
  [section setObject:@"Section" forKey:RHTableViewProviderSectionName];
  [section setObject:theContent forKey:RHTableViewProviderSectionRows];
  
  [mutable addObject:section];
  
  return mutable;
}

- (Class)tableCellClassForContentOption {
  
  return [RHTableViewProviderCell class];
}

- (NSString *)titleForSection:(NSUInteger)section
{
  return [[self.content objectAtIndex:section] valueForKey:RHTableViewProviderSectionName];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSMutableDictionary *sectionContent = [self.content objectAtIndex:section];
  NSInteger rows = [[sectionContent valueForKey:RHTableViewProviderSectionRows] count];
  return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  NSInteger sections = [self.content count];
  if (sections < 1) {
    sections = 1;
  }
  return sections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{  
  if (_hasSections) {
    return 25.0f;
  }
  
  return 0.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  NSDictionary *dictionary = [self.content objectAtIndex:section];
  return [dictionary valueForKey:RHTableViewProviderSectionName];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat height = 44.0f;
  Class cellClass = [self cellClassForRowAtIndexPath:indexPath];
  height = [cellClass height];
  return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if ([self.delegate respondsToSelector:@selector(RHTableViewProvider:tableView:didSelectRowAtIndexPath:)])
  {
    [self.delegate RHTableViewProvider:self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
  RHTableViewProviderCell *cell = nil;
  
  Class cellClass = [self cellClassForRowAtIndexPath:indexPath];
  NSString *identifier = NSStringFromClass(cellClass);
  
  cell = (RHTableViewProviderCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = (RHTableViewProviderCell *)[[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  
  [cell setIndexPath:indexPath];
  
  id object = [self objectAtIndexPath:indexPath];
  [cell populateWithObject:object];
  
  return cell;
}

- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *name = nil;
  
  if ([self.delegate respondsToSelector:@selector(classNameForCellAtIndexPath:)]) {
    name = [self.delegate classNameForCellAtIndexPath:indexPath];
  }
  
  if (!name) {
    name = @"RHTableViewProviderCellDefault";
  }
  
  return NSClassFromString(name);
}

#pragma mark - PullToRefresh

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{  
  CGFloat contentOffsetY = scrollView.contentOffset.y;
  if (contentOffsetY < -self.pullToRefreshDistance) {
    if (self.shouldPullToRefresh) {
      [self pullToRefresh];
    }
  }
}

- (void)pullToRefresh
{
  if (!self.delegate) {
    NSLog(@"RHTableViewProvider needs an eventDelegate set for pullToRefresh");
    return;
  }
  
  if (!self.pullToRefreshView)
  {
    self.pullToRefreshView = [[RHTableViewProviderRefreshView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.pullToRefreshDistance)];
  }
  
  [[(UIViewController *)self.delegate view] addSubview:self.pullToRefreshView];
  
  [UIView animateWithDuration:0.25 animations:^{
    
    [self.tableView setFrame:CGRectMake(0.0f, self.pullToRefreshDistance, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    
  } completion:^(BOOL finished) {
    
    [NSTimer scheduledTimerWithTimeInterval:self.pullToRefreshTimeout target:self selector:@selector(pullToRefreshFail) userInfo:nil repeats:NO];
  }];
  
  if ([self.delegate respondsToSelector:@selector(RHTableViewProvider:tableViewDidPullToRefresh:)]) {
    [self.delegate RHTableViewProvider:self tableViewDidPullToRefresh:self.tableView];
  }
}

- (void)pullToRefreshFail
{
  [self.pullToRefreshView removeFromSuperview];
  [UIView animateWithDuration:0.25 animations:^{
    [self.tableView setFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
  } completion:nil];
}

- (void)pullToRefreshComplete
{
  [self.pullToRefreshView removeFromSuperview];
  [UIView animateWithDuration:0.25 animations:^{
    [self.tableView setFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
  } completion:nil];
}

#pragma mark - Setup

- (void)setup
{
  [self setupTableView];
  [self setupDefaults];
}

- (void)setupTableView
{
  [self.tableView setDataSource:self];
  [self.tableView setDelegate:self];
  [self.tableView setTableFooterView:[UIView new]];
}

- (void)setupDefaults
{
  self.pullToRefreshDistance = PULL_TO_REFRESH_DISTANCE;
  self.pullToRefreshTimeout = PULL_TO_REFRESH_TIMEOUT;
}

@end
