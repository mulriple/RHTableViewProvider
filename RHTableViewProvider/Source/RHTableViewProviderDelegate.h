//
//  RHTableViewProviderDelegate.h
//  RHKit
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RHTableViewProvider;

@protocol RHTableViewProviderDelegate <NSObject>

@optional
- (NSString *)classNameForCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)RHTableViewProvider:(RHTableViewProvider *)provider tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)RHTableViewProvider:(RHTableViewProvider *)provider tableViewDidPullToRefresh:(UITableView *)tableView;
- (void)RHTableViewProvider:(RHTableViewProvider *)provider tableViewDidCancelPullToRefresh:(UITableView *)tableView;
@end
