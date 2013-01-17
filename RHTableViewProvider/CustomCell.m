//
//  CustomCell.m
//  RHTableViewProvider
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)populateWithObject:(id)object
{
  [super populateWithObject:object];
  [self.label setTextColor:[UIColor whiteColor]];
  [self.label setText:object];
}

- (void)drawContentView:(CGRect)rect
{
  [super drawContentView:rect];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
  CGContextFillRect(context, rect);
}

@end
