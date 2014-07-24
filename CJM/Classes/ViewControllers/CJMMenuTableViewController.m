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
#import "CJMAppDelegate.h"

typedef NS_ENUM(NSInteger, RowTitle) {
    RowSongs,
    RowArtists,
    RowGenre,
    RowYear,
    RowCount
};

@interface CJMMenuTableViewController ()

@property (nonatomic, strong) FWMArtistsTableViewController *artistsVC;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return RowCount;
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
    CJMMenuHeaderView *headerView = [[CJMMenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 400.0f)];
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _artistsVC = [[FWMArtistsTableViewController alloc] init];
    _songsVC = [[FWMSongsTableViewController alloc] init];
    _genreVC = [[FWMGenreTableViewController alloc] init];
    _performanceYearVC = [[FWMPerformanceYearTableViewController alloc] init];
}

- (NSString *)_titleForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case RowSongs:
            return NSLocalizedString(@"SONGS", nil);
            break;
            
        case RowArtists:
            return NSLocalizedString(@"ARTISTS", nil);
            break;
            
        case RowGenre:
            return NSLocalizedString(@"GENRES", nil);
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
