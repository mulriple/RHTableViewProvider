//
//  RHTableProvider.h
//  RHKit
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "RHTableViewProviderDelegate.h"
#import "RHTableViewProviderCell.h"

extern NSString *const RHTableViewProviderSectionHeader;
extern NSString *const RHTableViewProviderSectionFooter;
extern NSString *const RHTableViewProviderSectionRows;

@interface RHTableViewProvider : NSObject <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (assign, nonatomic) id <RHTableViewProviderDelegate> delegate;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *content;

@property (strong, nonatomic) UIView *emptyView;
@property (strong, nonatomic) UIView *pullToRefreshView;
@property (assign, nonatomic) BOOL shouldPullToRefresh;

@property (assign, nonatomic) CGFloat pullToRefreshDistance;
@property (assign, nonatomic) CGFloat pullToRefreshTimeout;
@property (assign, nonatomic) CGFloat defaultSectionHeight;

@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *sectionKeyPath;

@property (strong, nonatomic) NSString *defaultCellClassName;
@property (strong, nonatomic) NSString *defaultSectionHeaderViewClassName;
@property (strong, nonatomic) NSString *defaultSectionFooterViewClassName;

@property (strong, nonatomic) NSIndexPath *indexPathOfFirstRow;
@property (strong, nonatomic) NSIndexPath *indexPathOfLastRow;

- (id)initWithTableView:(UITableView *)aTableView delegate:(id<RHTableViewProviderDelegate>)aDelegate;

- (void)setup;

- (void)setContent:(NSArray *)theContent withSections:(BOOL)sections;
- (void)setContentWithFetchRequest:(NSFetchRequest *)aFetchRequest inContext:(NSManagedObjectContext *)aContext;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;

- (id)objectForSectionAtIndex:(NSInteger)index header:(BOOL)header;

- (Class)tableCellClassForRowAtIndexPath:(NSIndexPath *)indexPath;
- (Class)tableCellClassForContentOption;
- (Class)tableSectionViewClassForSection:(NSInteger)section header:(BOOL)header;

- (void)reload;
- (void)reloadVisibleCells;
- (void)displayWithoutData;
- (void)displayWithData;
- (BOOL)hasContent;
- (NSIndexPath *)indexPathOfFirstRow;
- (NSIndexPath *)indexPathOfLastRow;

- (void)pullToRefreshComplete;
- (void)pullToRefreshFail;

@end
