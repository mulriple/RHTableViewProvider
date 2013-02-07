//
//  RHAppDelegate.m
//  RHTableViewProvider
//
//  Created by Rob Hayward on 11/01/2013.
//  Copyright (c) 2013 Rob Hayward. All rights reserved.
//

#import "RHAppDelegate.h"
#import "ExamplesViewController.h"

@implementation RHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  ExamplesViewController *viewController = [[ExamplesViewController alloc] init];
  self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
