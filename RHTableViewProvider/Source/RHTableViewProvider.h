//
//  RHTableProvider.h
//  RHKit
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHTableViewProviderDelegate.h"
#import "RHTableViewProviderCell.h"

extern NSString *const RHTableViewProviderSectionName;
extern NSString *const RHTableViewProviderSectionRows;

@interface RHTableViewProvider : NSObject <UITableViewDataSource, UITableViewDelegate>
{
  BOOL _hasSections;
  NSInteger _totalItems;
}

@property (assign, nonatomic) id <RHTableViewProviderDelegate> delegate;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *content;

@property (strong, nonatomic) UIView *emptyView;
@property (strong, nonatomic) UIView *pullToRefreshView;
@property (assign, nonatomic) BOOL shouldPullToRefresh;

@property (assign, nonatomic) CGFloat pullToRefreshDistance;
@property (assign, nonatomic) CGFloat pullToRefreshTimeout;

- (id)initWithTableView:(UITableView *)aTableView delegate:(id<RHTableViewProviderDelegate>)aDelegate;

- (void)setup;

- (void)setContent:(NSArray *)theContent withSections:(BOOL)sections;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath;
- (Class)tableCellClassForContentOption;

- (void)reload;
- (void)reloadVisibleCells;
- (void)displayWithoutData;
- (void)displayWithData;
- (BOOL)hasContent;

- (void)pullToRefreshComplete;
- (void)pullToRefreshFail;
- (NSString *)titleForSection:(NSUInteger)section;

@end
