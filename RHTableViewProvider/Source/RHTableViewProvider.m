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
  
  if (self.fetchedResultsController)
  {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
  }
  
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

- (void)setContentWithFetchRequest:(NSFetchRequest *)aFetchRequest inContext:(NSManagedObjectContext *)aContext
{
  self.fetchRequest = aFetchRequest;
  self.context = aContext;
  self.fetchedResultsController = nil;
  
  NSError *error = nil;
  
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
  
  [self reload];
}

#pragma mark - Total Items Count

- (void)updateTotalItems
{
  _totalItems = [self totalItemsCount];
}

- (NSInteger)totalItemsCount
{
  if (self.fetchedResultsController)
  {
    return [[self.fetchedResultsController fetchedObjects] count];
  }
  
  NSInteger count = 0;
  
  for (NSDictionary *section in self.content) {
    count += [[section valueForKey:RHTableViewProviderSectionRows] count];
  }
  
  return count;
}

- (BOOL)hasContent {
  
  if (self.fetchedResultsController)
  {
    if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
      return YES;
    }
    return NO;
  }
  
  if (self.content) {
    if ([self.content count] > 0) {
      return YES;
    }
  }
  
  return NO;
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
  
  [section setObject:@"" forKey:RHTableViewProviderSectionName];
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
  NSInteger count = 0;
  if (self.fetchedResultsController)
  {
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    count = [sectionInfo numberOfObjects];
    return count;
  }
  
  NSMutableDictionary *sectionContent = [self.content objectAtIndex:section];
  count = [[sectionContent valueForKey:RHTableViewProviderSectionRows] count];
  return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  NSInteger count = 1;
  if (self.fetchedResultsController)
  {
    count = [[self.fetchedResultsController sections] count];
    return count;
  }
  
  count = [self.content count];
  if (count < 1) {
    count = 1;
  }
  return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{  
  if (_hasSections) {
    return self.defaultSectionHeight;
  }
  
  return 0.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if (self.fetchedResultsController) {
    return @"Sample Core Data Section Title";
  }
  
  NSDictionary *dictionary = [self.content objectAtIndex:section];
  NSString *title = [dictionary valueForKey:RHTableViewProviderSectionName];
  return title;
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
  
  if ([self.delegate respondsToSelector:@selector(RHTableViewProvider:didSelectRowAtIndexPath:)])
  {
    [self.delegate RHTableViewProvider:self didSelectRowAtIndexPath:indexPath];
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

#pragma mark - Core Data

- (NSFetchedResultsController *)fetchedResultsController {
  
  if (self.fetchRequest == nil) {
    return nil;
  }
  
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }
  
  NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.context sectionNameKeyPath:self.sectionKeyPath cacheName:nil];
  self.fetchedResultsController = theFetchedResultsController;
  self.fetchedResultsController.delegate = self;
  
  return _fetchedResultsController;
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
  self.pullToRefreshDistance = 70.0f;
  self.pullToRefreshTimeout = 10.0f;
  self.defaultSectionHeight = 20.0f;
}

@end
