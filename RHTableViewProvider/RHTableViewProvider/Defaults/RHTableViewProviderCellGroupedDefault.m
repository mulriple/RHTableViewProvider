//
//  RHTableViewProviderCellGroupedDefault.m
//  RHKit
//
//  Created by Rob Hayward on 16/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "RHTableViewProviderCellGroupedDefault.h"

#define BORDER_WIDTH 1.0f

@implementation RHTableViewProviderCellGroupedDefault

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, self.bounds.size.width - 20.0f, self.bounds.size.height - 20.0f)];
    [self.label setBackgroundColor:[UIColor clearColor]];
    [self.label setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [self.label setTextColor:[UIColor whiteColor]];
    [self.customView addSubview:self.label];
  }
  return self;
}

- (void)populateWithObject:(id)object
{
  [super populateWithObject:object];
  [self.label setText:object];
}

- (void)drawContentView:(CGRect)rect
{
  [super drawContentView:rect];
  [self drawGenericInRect:rect];
  
  switch (self.cellType) {
    case RHTableViewProviderCellTypeFirst:
      [self drawAsFirstCellInRect:rect];
      break;
    case RHTableViewProviderCellTypeLast:
      [self drawAsLastCellInRect:rect];
      break;
    default:
      [self drawAsStandardCellInRect:rect];
      break;
  }
}

- (void)drawGenericInRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextFillRect(context, rect);
  if (self.selected || self.highlighted) {
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    [self.label setTextColor:[UIColor whiteColor]];
  } else {
    CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
    [self.label setTextColor:[UIColor lightGrayColor]];
  }
  CGContextFillRect(context, rect);
}

- (void)drawAsStandardCellInRect:(CGRect)rect
{
  [self drawBottomBorderInRect:rect];
  [self drawSideBordersInRect:rect];
}

- (void)drawAsFirstCellInRect:(CGRect)rect
{
  [self drawBottomBorderInRect:rect];
  [self drawFirstCellBorderInRect:rect];
}

- (void)drawAsLastCellInRect:(CGRect)rect
{
  [self drawLastCellBorderInRect:rect];
}

- (void)drawFirstCellBorderInRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGFloat lineWidth = BORDER_WIDTH;
  CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
  CGContextSetLineWidth(context, lineWidth);
  CGFloat radius = self.cornerRadius;
  
  rect.origin.x = rect.origin.x + lineWidth;
  rect.origin.y = rect.origin.y + lineWidth;
  rect.size.width = rect.size.width - lineWidth;
  rect.size.height = rect.size.height - lineWidth;
  
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)];
  [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + radius)];
  [path addArcWithCenter:CGPointMake(rect.origin.x + radius, rect.origin.y + radius) radius:radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
  [path addLineToPoint:CGPointMake(rect.size.width - radius, rect.origin.y)];
  [path addArcWithCenter:CGPointMake(rect.size.width - radius, rect.origin.y + radius) radius:radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
  [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height + lineWidth)];
  [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
}

- (void)drawLastCellBorderInRect:(CGRect)rect
{
  CGFloat lineWidth = BORDER_WIDTH;
  CGFloat radius = self.cornerRadius;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
  CGContextSetLineWidth(context, lineWidth);
  
  rect.origin.x = rect.origin.x + lineWidth;
  rect.origin.y = rect.origin.y - lineWidth;
  rect.size.width = rect.size.width - lineWidth;
  rect.size.height = rect.size.height - lineWidth;
  
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
  [path addLineToPoint:CGPointMake(rect.origin.x, rect.size.height - radius)];
  [path addArcWithCenter:CGPointMake(rect.origin.x + radius, rect.size.height - radius) radius:radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(90) clockwise:NO];
  [path addLineToPoint:CGPointMake(rect.size.width - radius, rect.size.height)];
  [path addArcWithCenter:CGPointMake(rect.size.width - radius, rect.size.height - radius) radius:radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(0) clockwise:NO];
  [path addLineToPoint:CGPointMake(rect.size.width, rect.origin.y)];
  [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
}

- (void)drawBottomBorderInRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGFloat lineWidth = BORDER_WIDTH;
  CGContextSetLineWidth(context, lineWidth);
  CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
  CGContextMoveToPoint(context, rect.origin.x + lineWidth, rect.size.height - lineWidth);
  CGContextAddLineToPoint(context, rect.size.width - lineWidth, rect.size.height - lineWidth);
  CGContextStrokePath(context);
}

- (void)drawSideBordersInRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGFloat lineWidth = BORDER_WIDTH;
  CGContextSetLineWidth(context, lineWidth);
  CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
  
  CGContextMoveToPoint(context, lineWidth, 0);
  CGContextAddLineToPoint(context, lineWidth, rect.size.height);
  CGContextStrokePath(context);
  
  CGContextMoveToPoint(context, rect.size.width - lineWidth, 0);
  CGContextAddLineToPoint(context, rect.size.width - lineWidth, rect.size.height);
  CGContextStrokePath(context);
}

@end
