//
//  CJMMenuTableViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/15/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMMenuTableViewController.h"
#import "CJMMenuHeaderView.h"
#import "CJMTaglineView.h"
#import "CJMAppDelegate.h"
#import "CJMArtistsViewController.h"
#import "CJMPerformanceYearViewController.h"
#import "CJMSongsViewController.h"
#import "CJMGenreViewController.h"
#import "CJMMenuTableViewCell.h"

typedef NS_ENUM(NSInteger, RowTitle) {
    RowArtists,
    RowYear,
    RowSongs,
    RowGenre,
    RowCount
};

@interface CJMMenuTableViewController ()

@property (nonatomic, strong) CJMArtistsViewController *artistsVC;
@property (nonatomic, strong) CJMSongsViewController *songsVC;
@property (nonatomic, strong) CJMGenreViewController *genreVC;
@property (nonatomic, strong) CJMPerformanceYearViewController *performanceYearVC;
@property (nonatomic, strong) NSIndexPath *selectedIndex;

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 125.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    CJMMenuTableViewCell *cell = (CJMMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CJMMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self _titleForIndexPath:indexPath];
    cell.textLabel.font = [UIFont tableViewHeaderFont];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell bringSubviewToFront:cell.textLabel];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    if (self.selectedIndex == indexPath) {
        cell.textLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"highlighted"]];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.textLabel.bounds];
    imageView.image = [UIImage imageNamed:@"highlighted"];
    cell.selectedBackgroundView = imageView;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(140.0f, 56.0f, 40.0f, 4.0f)];
    separatorView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:separatorView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
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
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)_initialize
{
    _selectedIndex = [NSIndexPath indexPathForItem:0 inSection:0]; 
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"sidebar"];
    self.tableView.backgroundView = imageView;
    CJMMenuHeaderView *headerView = [[CJMMenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[CJMMenuTableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!_artistsVC) {
        _artistsVC = [[CJMArtistsViewController alloc] init];
    }
    
    if (!_songsVC) {
        _songsVC = [[CJMSongsViewController alloc] init];
    }
    
    if (!_genreVC) {
        _genreVC = [[CJMGenreViewController alloc] init];
    }
    
    if (!_performanceYearVC) {
        _performanceYearVC = [[CJMPerformanceYearViewController alloc] init];
    }
    
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
