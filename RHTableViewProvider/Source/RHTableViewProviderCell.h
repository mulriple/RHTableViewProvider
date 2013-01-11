//
//  RHTableViewProviderCell.h
//  RHKit
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHTableViewProviderCell : UITableViewCell

@property (strong, nonatomic) UIView *customView;
@property (strong, nonatomic) id object;
@property (strong, nonatomic) NSIndexPath *indexPath;

- (void)drawContentView:(CGRect)rect;
- (CGRect)customViewFrame;

+ (CGFloat)height;
- (void)populateWithObject:(id)object;

@end
