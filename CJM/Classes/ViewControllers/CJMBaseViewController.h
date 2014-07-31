//
//  CJMBaseViewController.h
//  CJM
//
//  Created by Michael Fellows on 7/29/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJMSearchHeaderView.h"
#import "CJMTableViewCell.h"
#import "CJMAudioController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CJMTableHeaderView.h"
#import "CJMTrackPlayingView.h"

#define kCellIdentifier @"CellIdentifier"

@interface CJMBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) CJMSearchHeaderView *tableHeaderView;
@property (nonatomic, weak) CJMTrackPlayingView *trackPlayingView; 

- (NSString *)timeRemainingForDuration:(NSNumber *)duration; 
- (void)populateTrackView; 
@end

