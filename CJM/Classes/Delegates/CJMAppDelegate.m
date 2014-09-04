//
//  CJMAppDelegate.m
//  CJM
//
//  Created by Michael Fellows on 7/15/14
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMAppDelegate.h"
#import "CJMBaseNavigationController.h"
#import "CJMSplitViewController.h"
#import "CJMArtistsViewController.h"

@implementation CJMAppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.menuTableViewController = [[CJMMenuTableViewController alloc] init];
    CJMArtistsViewController *detailTableViewController = [[CJMArtistsViewController alloc] init];
    CJMBaseNavigationController *navController = [[CJMBaseNavigationController alloc] initWithRootViewController:self.menuTableViewController];
    CJMBaseNavigationController *detailNav = [[CJMBaseNavigationController alloc] initWithRootViewController:detailTableViewController];
    
    self.splitViewController = [[CJMSplitViewController alloc] init];
    self.splitViewController.viewControllers = @[ navController, detailNav ];
    self.window.rootViewController = self.splitViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
