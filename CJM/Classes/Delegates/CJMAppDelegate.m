//
//  CJMAppDelegate.m
//  CJM
//
//  Created by Michael Fellows on 7/15/14
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMAppDelegate.h"
#import "CJMMenuTableViewController.h"
#import "FWMSongsTableViewController.h"
#import "CJMBaseNavigationController.h"

@implementation CJMAppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CJMMenuTableViewController *menuTableViewController = [[CJMMenuTableViewController alloc] init];
    FWMSongsTableViewController *detailTableViewController = [[FWMSongsTableViewController alloc] init];
    CJMBaseNavigationController *navController = [[CJMBaseNavigationController alloc] initWithRootViewController:menuTableViewController];
    CJMBaseNavigationController *detailNav = [[CJMBaseNavigationController alloc] initWithRootViewController:detailTableViewController];
    
    self.splitViewController = [[UISplitViewController alloc] init];
    self.splitViewController.viewControllers = @[ navController, detailNav ];
    self.window.rootViewController = self.splitViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
