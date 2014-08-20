//
//  CJMYearMenuTableViewController.m
//  CJM
//
//  Created by Michael Fellows on 8/19/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMYearMenuTableViewController.h"
#import "CJMSidePanelTableViewCell.h"
#import "CJMMenuTableViewController.h"
#import "JASidePanelController.h"
#import <MediaPlayer/MediaPlayer.h>

static NSString * const CellIdentifier = @"YearCellIdentifier";

@interface CJMYearMenuTableViewController ()

@property (nonatomic, copy) NSArray *years;
@property (nonatomic, strong) CJMMenuTableViewController *menuController;

@end

@implementation CJMYearMenuTableViewController

- (instancetype)initWithMenuController:(CJMMenuTableViewController *)menuController
{
    if ((self = [super init])) {
        _menuController = menuController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 400.0f, 200.0f);
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView; 
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    
    NSMutableArray *allYears = [NSMutableArray array];
    for (MPMediaItem *item in songs) {
        NSNumber *year = [item valueForKey:@"year"];
        if (year) [allYears addObject:year];
    }
    
    self.years = [[NSSet setWithArray:allYears] allObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.years.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJMSidePanelTableViewCell *cell = (CJMSidePanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CJMSidePanelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSNumber *year = [self.years objectAtIndex:indexPath.row];
    cell.itemLabel.text = [[NSString stringWithFormat:@"%@", year] uppercaseString];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.menuController.yearSidePanelController showCenterPanelAnimated:YES];
    NSNumber *year = [self.years objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedYear"
                                                        object:@{ @"year" : year }];
}
@end
