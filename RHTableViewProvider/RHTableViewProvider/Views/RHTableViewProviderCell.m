//
//  RHTableViewProviderCell.m
//  RHKit
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "RHTableViewProviderCell.h"
#import "RHTableViewProviderCellView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RHTableViewProviderCell

@synthesize customView, object;

+ (CGFloat)height
{
  return 44.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setSelectionStyle:UITableViewCellEditingStyleNone];
    self.customView = [[RHTableViewProviderCellView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.customView];
  }
  return self;
}

- (void)group
{
  [self setIsGrouped:YES];
  [self setBackgroundView:[UIView new]];
  [self setFrame:CGRectZero];
}

- (void)unGroup
{
  [self setIsGrouped:NO];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
  CGRect customViewFrame = self.contentView.frame;
  if (self.isGrouped) { customViewFrame = [self groupedRect]; }
  self.customView.frame = customViewFrame;
	[self setNeedsDisplay];
}

#pragma mark - Getters

- (CGRect)groupedRect
{
  CGRect rect = self.frame;
  CGFloat margin = ceilf(rect.size.width * 0.03f);
  return CGRectMake(margin, rect.origin.x, rect.size.width - (margin * 2), rect.size.height);
}

- (void)setNeedsDisplay
{
	[super setNeedsDisplay];
	[self.customView setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
  [super setHighlighted:highlighted animated:animated];
  [self setNeedsDisplay];
}

#pragma mark - Template methods

- (void)populateWithObject:(id)anObject
{
  self.object = anObject;
}

- (void)drawContentView:(CGRect)rect
{
  if (self.isGrouped) { [self drawGroupedMaskInRect:rect]; }
}

- (void)drawGroupedMaskInRect:(CGRect)rect
{
  if (self.isFirstCell)
  {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.f)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    self.customView.layer.mask = maskLayer;
  }
  else if (self.isLastCell)
  {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10.0f, 10.f)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    self.customView.layer.mask = maskLayer;
  }
}

@end
