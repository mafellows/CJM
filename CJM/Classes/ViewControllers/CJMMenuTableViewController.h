//
//  CJMMenuTableViewController.h
//  CJM
//
//  Created by Michael Fellows on 7/15/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JASidePanelController; 

@interface CJMMenuTableViewController : UITableViewController <UISplitViewControllerDelegate> \

@property (nonatomic, strong) JASidePanelController *genreSidePanelController;
@property (nonatomic, strong) JASidePanelController *yearSidePanelController;
@property (nonatomic, strong) JASidePanelController *artistSidePanelController;

- (void)showScreenAtCurrentIndex;

@end
