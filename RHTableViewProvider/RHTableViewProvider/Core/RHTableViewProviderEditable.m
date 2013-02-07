//
//  RHTableViewProviderEditable.m
//  RHTableViewProvider
//
//  Created by Rob Hayward on 07/02/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "RHTableViewProviderEditable.h"

@implementation RHTableViewProviderEditable

#pragma mark - Editing

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    if ([self.delegate respondsToSelector:@selector(RHTableViewProvider:tableViewShoudDeleteRowAtIndexPath:)]) {
      [self.delegate RHTableViewProvider:self tableViewShoudDeleteRowAtIndexPath:indexPath];
    }
  }
}

@end
