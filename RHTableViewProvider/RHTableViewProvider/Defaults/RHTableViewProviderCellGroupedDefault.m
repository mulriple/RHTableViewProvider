//
//  RHTableViewProviderCellGroupedDefault.m
//  RHKit
//
//  Created by Rob Hayward on 16/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "RHTableViewProviderCellGroupedDefault.h"

@implementation RHTableViewProviderCellGroupedDefault

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, self.bounds.size.width - 20.0f, self.bounds.size.height - 20.0f)];
    [self.label setBackgroundColor:[UIColor clearColor]];
    [self.label setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [self.customView addSubview:self.label];
    
    self.borderColor = [UIColor redColor];
    self.backgroundColorDefault = [UIColor whiteColor];
    self.backgroundColorDefaultHighlighted = [UIColor blueColor];
    self.textColor = [UIColor darkGrayColor];
    self.textColorHighlighted = [UIColor whiteColor];
    self.borderWith = 1.0f;
  }
  return self;
}

- (void)populateWithObject:(id)object
{
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
    case RHTableViewProviderCellTypeSingle:
      [self drawAsSingleCellInRect:rect];
      break;
    case RHTableViewProviderCellTypeMiddle:
      [self drawAsStandardCellInRect:rect];
      break;
  }
}

- (void)drawGenericInRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextFillRect(context, rect);
  if (self.selected || self.highlighted) {
    CGContextSetFillColorWithColor(context, [self.backgroundColorDefaultHighlighted CGColor]);
    [self.label setTextColor:self.textColorHighlighted];
  } else {
    CGContextSetFillColorWithColor(context, [self.backgroundColorDefault CGColor]);
    [self.label setTextColor:self.textColor];
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

- (void)drawAsSingleCellInRect:(CGRect)rect
{
  CGFloat lineWidth = self.borderWith;
  CGFloat radius = self.cornerRadius;
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
  
  rect.origin.x = rect.origin.x + (lineWidth / 2);
  rect.origin.y = rect.origin.y + (lineWidth / 2);
  rect.size.width = rect.size.width - (lineWidth / 2);
  rect.size.height = rect.size.height - (lineWidth / 2);
  
  // top
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path setLineWidth:lineWidth];
  [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - radius)];
  [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + radius)];
  [path addArcWithCenter:CGPointMake(rect.origin.x + radius, rect.origin.y + radius) radius:radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
  [path addLineToPoint:CGPointMake(rect.size.width - radius, rect.origin.y)];
  [path addArcWithCenter:CGPointMake(rect.size.width - radius, rect.origin.y + radius) radius:radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
  [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height + lineWidth - radius)];
  [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
  
  // bottom
  [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + radius)];
  [path addLineToPoint:CGPointMake(rect.origin.x, rect.size.height - radius)];
  [path addArcWithCenter:CGPointMake(rect.origin.x + radius, rect.size.height - radius) radius:radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(90) clockwise:NO];
  [path addLineToPoint:CGPointMake(rect.size.width - radius, rect.size.height)];
  [path addArcWithCenter:CGPointMake(rect.size.width - radius, rect.size.height - radius) radius:radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(0) clockwise:NO];
  [path addLineToPoint:CGPointMake(rect.size.width, rect.origin.y + radius)];
  [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
}

- (void)drawFirstCellBorderInRect:(CGRect)rect
{
  CGFloat lineWidth = self.borderWith;
  CGFloat radius = self.cornerRadius;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
  
  rect.origin.x = rect.origin.x + (lineWidth / 2);
  rect.origin.y = rect.origin.y + (lineWidth / 2);
  rect.size.width = rect.size.width - (lineWidth / 2);
  rect.size.height = rect.size.height - (lineWidth / 2);
  
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path setLineWidth:lineWidth];
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
  CGFloat lineWidth = self.borderWith;
  CGFloat radius = self.cornerRadius;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
  
  rect.origin.x = rect.origin.x + (lineWidth / 2);
  rect.origin.y = rect.origin.y - (lineWidth / 2);
  rect.size.width = rect.size.width - (lineWidth / 2);
  rect.size.height = rect.size.height - (lineWidth / 2);
  
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path setLineWidth:lineWidth];
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
  CGFloat lineWidth = self.borderWith;
  CGContextSetLineWidth(context, lineWidth);
  CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
  CGContextMoveToPoint(context, rect.origin.x + (lineWidth / 2), rect.size.height - (lineWidth / 2));
  CGContextAddLineToPoint(context, rect.size.width - (lineWidth / 2), rect.size.height - (lineWidth / 2));
  CGContextStrokePath(context);
}

- (void)drawSideBordersInRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGFloat lineWidth = self.borderWith;
  CGContextSetLineWidth(context, lineWidth);
  CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
  
  CGContextMoveToPoint(context, (lineWidth / 2), 0);
  CGContextAddLineToPoint(context, (lineWidth / 2), rect.size.height);
  CGContextStrokePath(context);
  
  CGContextMoveToPoint(context, rect.size.width - (lineWidth / 2), 0);
  CGContextAddLineToPoint(context, rect.size.width - (lineWidth / 2), rect.size.height);
  CGContextStrokePath(context);
}

@end
