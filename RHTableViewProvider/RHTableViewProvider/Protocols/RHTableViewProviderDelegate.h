//
//  RHTableViewProviderDelegate.h
//  RHTableViewProvider
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RHTableViewProvider;

@protocol RHTableViewProviderDelegate <NSObject>

@optional
- (NSString *)tableCellClassForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableSectionHeaderViewClassForSection:(NSInteger)section;
- (NSString *)tableSectionFooterViewClassForSection:(NSInteger)section;

- (void)RHTableViewProvider:(RHTableViewProvider *)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)RHTableViewProvider:(RHTableViewProvider *)provider tableViewDidPullToRefresh:(UITableView *)tableView;
- (void)RHTableViewProvider:(RHTableViewProvider *)provider tableViewDidCancelPullToRefresh:(UITableView *)tableView;

- (void)RHTableViewProvider:(RHTableViewProvider *)provider tableViewShoudDeleteRowAtIndexPath:(NSIndexPath *)indexPath;

@end
