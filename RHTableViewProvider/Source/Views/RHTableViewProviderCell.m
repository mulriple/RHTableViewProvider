//
//  RHTableViewProviderCell.m
//  RHKit
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "RHTableViewProviderCell.h"
#import "RHTableViewProviderCellView.h"

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
    self.customView = [[RHTableViewProviderCellView alloc] initWithFrame:self.contentView.frame];
    [self addSubview:self.customView];
  }
  return self;
}

#pragma mark - Getters

- (CGRect)customViewFrame
{
  return CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
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
	// Subclasses should implement this
}

@end
