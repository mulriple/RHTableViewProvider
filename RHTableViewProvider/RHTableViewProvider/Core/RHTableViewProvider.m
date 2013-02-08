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
#import "RHTableViewProviderSection.h"
#import "NSDictionary+RHTVP.h"

NSString *const RHTableViewProviderSectionHeader = @"RHTableViewProviderSectionHeader";
NSString *const RHTableViewProviderSectionFooter = @"RHTableViewProviderSectionFooter";
NSString *const RHTableViewProviderSectionRows = @"RHTableViewProviderSectionRows";

@interface RHTableViewProvider ()
{
  BOOL _hasSections;
  NSInteger _totalItems;
}
@end

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

#pragma mark - Getters

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

- (id)objectForSectionAtIndex:(NSInteger)index header:(BOOL)header
{
  NSDictionary *section = [self.content objectAtIndex:index];
  if (header) {
    return [section objectForKeyNotNull:RHTableViewProviderSectionHeader];
  }
  return [section objectForKeyNotNull:RHTableViewProviderSectionFooter];
}

- (NSIndexPath *)indexPathOfFirstRow
{
  return [NSIndexPath indexPathForItem:0 inSection:0];
}

- (NSIndexPath *)indexPathOfLastRow
{
  if (_indexPathOfLastRow != nil) {
    return _indexPathOfLastRow;
  }
  
  NSInteger section = [self.content count];
  if (section > 0) { section -= 1; }
  NSInteger count = [[[self.content objectAtIndex:section] objectForKey:RHTableViewProviderSectionRows] count];
  if (count > 1) { count -= 1; }
  self.indexPathOfLastRow = [NSIndexPath indexPathForItem:count inSection:section];
  return _indexPathOfLastRow;
}

- (BOOL)isIndexPathFirstRowOfSection:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) { return YES; }
  return NO;
}

- (BOOL)isIndexPathLastRowOfSection:(NSIndexPath *)indexPath
{
  NSInteger count = [[[self.content objectAtIndex:indexPath.section] objectForKey:RHTableViewProviderSectionRows] count];
  if (indexPath.row == (count - 1)) { return YES; }
  return NO;
}

- (BOOL)isCellSingleInSectionForIndexPath:(NSIndexPath *)indexPath
{
  NSInteger count = [[[self.content objectAtIndex:indexPath.section] objectForKey:RHTableViewProviderSectionRows] count];
  if (count > 1) {
    return NO;
  }
  return YES;
}

- (CGFloat)cellWidth
{
  if (!self.tableView.style == UITableViewStyleGrouped) { return self.tableView.frame.size.width; }
  else
  {
    return (self.tableView.frame.size.width - ((self.tableView.frame.size.width * GROUPED_CELL_WIDTH_MULTIPLIER) * 2));
  }
}

#pragma mark - Setters

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *section = [self.content objectAtIndex:indexPath.section];
  NSMutableArray *rows = [section valueForKey:RHTableViewProviderSectionRows];
  id object = [rows objectAtIndex:indexPath.row];
  if (object) {
    [rows removeObjectAtIndex:indexPath.row];
  }
}

- (void)setContent:(NSArray *)theContent withSections:(BOOL)sections
{  
  _hasSections = sections;
  
  if (theContent == nil)
  {
    self.content = [[NSArray alloc] init];
  }
  else
  {
    if (_hasSections) {
      self.content = theContent;
    } else {
      self.content = [self contentWithSections:theContent];
    }
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
  self.indexPathOfLastRow = nil;
  
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
  for (RHTableViewProviderCell *cell in visibleCells)
  {  
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
  [section setObject:theContent forKey:RHTableViewProviderSectionRows];
  [mutable addObject:section];
  return mutable;
}

- (Class)tableCellClassForContentOption {
  
  return [RHTableViewProviderCell class];
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
//  NSInteger count = 1;
  NSInteger count = 0;
  if (self.fetchedResultsController)
  {
    count = [[self.fetchedResultsController sections] count];
    return count;
  }
  count = [self.content count];
//  if (count < 1) { count = 1; }
  return count;
}

- (CGFloat)heightForSectionAtIndex:(NSInteger)index header:(BOOL)header
{
  CGFloat height = 0.0f;
  
  if (_hasSections) { height = self.defaultSectionHeight; }
  
  Class viewClass = [self tableSectionViewClassForSection:index header:header];
  if (viewClass)
  { return [viewClass height]; }
  else
  {
    id object = [self objectForSectionAtIndex:index header:header];
    if (!object) { height = 0.0f; }
  }
  return height;
}

#pragma mark - Sections

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return [self heightForSectionAtIndex:section header:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return [self heightForSectionAtIndex:section header:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if (self.fetchedResultsController) {
    return @"Placeholder Section Header Title";
  }
  return [self objectForSectionAtIndex:section header:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  if (self.fetchedResultsController) {
    return @"Placeholder Section Footer Title";
  }
  return [self objectForSectionAtIndex:section header:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  Class viewClass = [self tableSectionViewClassForSection:section header:YES];
  if (!viewClass) {
    return nil;
  }
  id <RHTableViewProviderSection> view = [[viewClass alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [viewClass height])];
  
  id object = [self objectForSectionAtIndex:section header:YES];
  [view populateWithObject:object];
  
  return (UIView *)view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  Class viewClass = [self tableSectionViewClassForSection:section header:NO];
  if (!viewClass) {
    return nil;
  }
  id <RHTableViewProviderSection> view = [[viewClass alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [viewClass height])];
  
  id object = [self objectForSectionAtIndex:section header:NO];
  [view populateWithObject:object];
  
  return (UIView *)view;
}

#pragma mark - Rows

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat height = 44.0f;
  if (_shouldDrawCustomViews)
  {
    [[self tableCellClassForRowAtIndexPath:indexPath] height];
  }
  return height;
}

#pragma mark - Cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  id object = [self objectAtIndexPath:indexPath];
  Class cellClass = [self tableCellClassForRowAtIndexPath:indexPath];
  NSString *identifier = NSStringFromClass(cellClass);

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  
  if ([cell isKindOfClass:[RHTableViewProviderCell class]])
  {
    if ([self isCellSingleInSectionForIndexPath:indexPath]) { [(RHTableViewProviderCell *)cell setCellType:RHTableViewProviderCellTypeSingle]; }
    else if ([self isIndexPathFirstRowOfSection:indexPath]) { [(RHTableViewProviderCell *)cell setCellType:RHTableViewProviderCellTypeFirst]; }
    else if ([self isIndexPathLastRowOfSection:indexPath]) { [(RHTableViewProviderCell *)cell setCellType:RHTableViewProviderCellTypeLast]; }
    else { [(RHTableViewProviderCell *)cell setCellType:RHTableViewProviderCellTypeMiddle]; }
    
    if (self.tableView.style == UITableViewStyleGrouped) { [(RHTableViewProviderCell *)cell group]; }
    else { [(RHTableViewProviderCell *)cell unGroup]; }
    
    [(RHTableViewProviderCell *)cell setCornerRadius:self.groupedCellCornerRadius];
    [(RHTableViewProviderCell *)cell setIndexPath:indexPath];
    [(RHTableViewProviderCell *)cell populateWithObject:object];
  }
  else
  {
    cell.textLabel.text = object;
  }
  
  return cell;
}

#pragma mark - Row Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ([self.delegate respondsToSelector:@selector(RHTableViewProvider:didSelectRowAtIndexPath:)])
  {
    [self.delegate RHTableViewProvider:self didSelectRowAtIndexPath:indexPath];
  }
}

#pragma mark - Custom Views

- (Class)tableCellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (!_shouldDrawCustomViews) { return [UITableViewCell class]; }
  
  NSString *name = nil;
  if ([self.delegate respondsToSelector:@selector(tableCellClassForRowAtIndexPath:)]) {
    name = [self.delegate tableCellClassForRowAtIndexPath:indexPath];
  }
  if (name == nil) {
    name = self.defaultCellClassName;
    if (self.tableView.style == UITableViewStyleGrouped) {
      name = self.defaultGroupedCellClassName;
    }
  }
  return NSClassFromString(name);
}

- (Class)tableSectionViewClassForSection:(NSInteger)section header:(BOOL)header
{
  if (!_shouldDrawCustomViews) { return nil; }
  
  id object = [self objectForSectionAtIndex:section header:header];
  if (!object) {
    return nil;
  }
  
  NSString *name = nil;
  
  if (header)
  {
    if (self.tableView.style == UITableViewStylePlain) { name = self.defaultSectionHeaderViewClassName; }
    else { name = name = self.defaultGroupedSectionHeaderViewClassName; }
    
    if ([self.delegate respondsToSelector:@selector(tableSectionHeaderViewClassForSection:)])
    {
      name = [self.delegate tableSectionHeaderViewClassForSection:section];
    }
  }
  else
  {
    if (self.tableView.style == UITableViewStylePlain) { name = self.defaultSectionFooterViewClassName; }
    else { name = name = self.defaultGroupedSectionFooterViewClassName; }
    
    if ([self.delegate respondsToSelector:@selector(tableSectionFooterViewClassForSection:)]) {
      name = [self.delegate tableSectionFooterViewClassForSection:section];
    }
  }
  
  if (name != nil) {
    return NSClassFromString(name);
  }
  
  return nil;
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
  self.groupedCellCornerRadius = 10.0f;
  self.defaultCellClassName = @"RHTableViewProviderCellDefault";
  self.defaultGroupedCellClassName = @"RHTableViewProviderCellGroupedDefault";
  self.defaultSectionHeaderViewClassName = @"RHTableViewProviderSectionViewDefault";
  self.defaultSectionFooterViewClassName = @"RHTableViewProviderSectionViewDefault";
  self.defaultGroupedSectionHeaderViewClassName = @"RHTableViewProviderSectionViewGroupedDefault";
  self.defaultGroupedSectionFooterViewClassName = @"RHTableViewProviderSectionViewGroupedDefault";
}

@end
