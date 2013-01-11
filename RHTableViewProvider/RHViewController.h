//
//  RHViewController.h
//  RHTableViewProvider
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHTableViewProviderDelegate.h"

@interface RHViewController : UIViewController <RHTableViewProviderDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end
