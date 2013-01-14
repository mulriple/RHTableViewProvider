//
//  RHTableViewProviderSectionViewDefault.m
//  RHTableViewProvider
//
//  Created by Rob Hayward on 14/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "RHTableViewProviderSectionViewDefault.h"

@implementation RHTableViewProviderSectionViewDefault

+ (CGFloat)height
{
  return 24.0f;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:[UIColor blackColor]];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, self.bounds.size.width - 20.0f, self.bounds.size.height - 10.0f)];
    [self.label setBackgroundColor:[UIColor clearColor]];
    [self.label setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [self.label setTextColor:[UIColor whiteColor]];
    [self addSubview:self.label];
  }
  return self;
}

- (void)populateWithObject:(id)theObject
{
  self.object = theObject;
  [self.label setText:self.object];
}

@end
