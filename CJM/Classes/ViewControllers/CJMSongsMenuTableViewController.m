//
//  CJMSongsMenuTableViewController.m
//  CJM
//
//  Created by Michael Fellows on 9/8/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMSongsMenuTableViewController.h"
#import "CJMSidePanelTableViewCell.h"
#import "CJMMenuTableViewController.h"
#import "JASidePanelController.h"
#import <MediaToolbox/MediaToolbox.h> 

static NSString * const CJMSongMenuCellIdentifier = @"SongMenuCellIdentifier";

@interface CJMSongsMenuTableViewController ()

@property (nonatomic, copy) NSArray *songLetters;
@property (nonatomic, strong) CJMMenuTableViewController *menuController;

@end

@implementation CJMSongsMenuTableViewController

- (instancetype)initWithMenuController:(CJMMenuTableViewController *)menuController
{
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _menuController = menuController;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self initWithMenuController:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songLetters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJMSidePanelTableViewCell *cell = (CJMSidePanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CJMSongMenuCellIdentifier];
    if (!cell) {
        cell = [[CJMSidePanelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CJMSongMenuCellIdentifier];
    }
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.menuController.yearSidePanelController showCenterPanelAnimated:YES];
//    NSNumber *year = [self.years objectAtIndex:indexPath.row];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedYear"
//                                                        object:@{ @"year" : year }];
}

@end
