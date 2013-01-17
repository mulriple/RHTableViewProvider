//
//  RHTableViewProviderCell.h
//  RHKit
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHTableViewProviderCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIView *customView;
@property (assign, nonatomic) BOOL isFirstCell;
@property (assign, nonatomic) BOOL isLastCell;
@property (assign, nonatomic) BOOL isGrouped;
@property (strong, nonatomic) id object;

- (void)drawContentView:(CGRect)rect;
- (CGRect)groupedRect;

+ (CGFloat)height;
- (void)populateWithObject:(id)object;

- (void)group;
- (void)unGroup;

@end
