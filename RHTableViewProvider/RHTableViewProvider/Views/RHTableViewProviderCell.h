//
//  RHTableViewProviderCell.h
//  RHKit
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees)/ 180)

typedef enum
{
  RHTableViewProviderCellTypeFirst,
  RHTableViewProviderCellTypeLast,
  RHTableViewProviderCellTypeMiddle,
  RHTableViewProviderCellTypeSingle
} RHTableViewProviderCellType;

@interface RHTableViewProviderCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIView *customView;
@property (assign, nonatomic) BOOL isGrouped;
@property (strong, nonatomic) id object;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) RHTableViewProviderCellType cellType;

@property (strong, nonatomic) UIColor *backgroundColorDefault;
@property (strong, nonatomic) UIColor *backgroundColorDefaultHighlighted;
@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *textColorHighlighted;
@property (assign, nonatomic) CGFloat borderWith;

- (void)drawContentView:(CGRect)rect;
- (CGRect)groupedRect;

+ (CGFloat)height;
- (void)populateWithObject:(id)object;

- (void)group;
- (void)unGroup;

@end
