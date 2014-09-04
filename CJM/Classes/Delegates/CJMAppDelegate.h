//
//  CJMAppDelegate.h
//  CJM
//
//  Created by Michael Fellows on 7/15/14
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMSplitViewController.h"
#import "CJMMenuTableViewController.h"

@interface CJMAppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CJMSplitViewController *splitViewController;
@property (strong, nonatomic) CJMMenuTableViewController *menuTableViewController;

@end
