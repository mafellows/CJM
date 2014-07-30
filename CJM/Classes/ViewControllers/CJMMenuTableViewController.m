//
//  CJMMenuTableViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/15/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMMenuTableViewController.h"
#import "CJMMenuHeaderView.h"
#import "FWMArtistsTableViewController.h"
#import "FWMSongsTableViewController.h"
#import "FWMGenreTableViewController.h"
#import "FWMPerformanceYearTableViewController.h"
#import "CJMTaglineView.h"
#import "CJMAppDelegate.h"
#import "CJMBaseViewController.h"

typedef NS_ENUM(NSInteger, RowTitle) {
    RowArtists,
    RowYear,
    RowSongs,
    RowGenre,
    RowCount
};

@interface CJMMenuTableViewController ()

@property (nonatomic, strong) CJMBaseViewController *artistsVC;
@property (nonatomic, strong) FWMSongsTableViewController *songsVC;
@property (nonatomic, strong) FWMGenreTableViewController *genreVC;
@property (nonatomic, strong) FWMPerformanceYearTableViewController *performanceYearVC;

@end

@implementation CJMMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES; 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return RowCount;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CJMTaglineView *taglineView = [[CJMTaglineView alloc] init];
    return taglineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 125.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self _titleForIndexPath:indexPath];
    cell.textLabel.font = [UIFont tableViewHeaderFont];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id presentingViewController = nil;
    
    switch (indexPath.row) {
        case RowSongs:
            presentingViewController = self.songsVC;
            break;
            
        case RowArtists:
            presentingViewController = self.artistsVC;
            break;
            
        case RowGenre:
            presentingViewController = self.genreVC;
            break;
            
        case RowYear:
            presentingViewController = self.performanceYearVC;
            break;
            
        default:
            break;
    }
    
    CJMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSArray *newViewControllerStack = @[ [delegate.splitViewController.viewControllers firstObject], presentingViewController];
    delegate.splitViewController.viewControllers = newViewControllerStack;
    delegate.splitViewController.delegate = self; 
}

#pragma mark - Private

- (void)_initialize
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"sidebar"];
    self.tableView.backgroundView = imageView;
    CJMMenuHeaderView *headerView = [[CJMMenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _artistsVC = [[CJMBaseViewController alloc] init];
    _songsVC = [[FWMSongsTableViewController alloc] init];
    _genreVC = [[FWMGenreTableViewController alloc] init];
    _performanceYearVC = [[FWMPerformanceYearTableViewController alloc] init];
}

- (NSString *)_titleForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case RowSongs:
            return NSLocalizedString(@"SONG TITLE", nil);
            break;
            
        case RowArtists:
            return NSLocalizedString(@"ARTISTS", nil);
            break;
            
        case RowGenre:
            return NSLocalizedString(@"GENRE", nil);
            break;
            
        case RowYear:
            return NSLocalizedString(@"PERFORMANCE YEAR", nil);
            break;
            
        default:
            return nil;
            break;
    }
}

@end
