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
#import "CJMYearMenuTableViewController.h"
#import "CJMGenreMenuTableViewController.h"
#import "CJMSongsViewController.h"
#import "CJMGenreViewController.h"
#import "JASidePanelController.h"
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
@property (nonatomic, strong) CJMGenreMenuTableViewController *genreMenuTableViewController;
@property (nonatomic, strong) CJMYearMenuTableViewController *yearMenuTableViewController;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _presentInitialViewController];
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
    static NSString *CellIdentifier = @"MenuCellIdentifier";
    CJMMenuTableViewCell *cell = (CJMMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CJMMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.menuTitleLabel.text = [self _titleForIndexPath:indexPath];
    cell.highlightedView.backgroundColor = [UIColor clearColor];
    
    if (self.selectedIndex.row == indexPath.row) {
        cell.highlightedView.backgroundColor = [UIColor colorWithRed:255.0f / 255.0f green:170.0f / 255.0f blue:2.0f / 255.0f alpha:1.0f];
    }
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
            self.genreSidePanelController.leftPanel = self.genreMenuTableViewController;
            self.genreSidePanelController.centerPanel = self.genreVC;
            presentingViewController = self.genreSidePanelController;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"genreMenuTapped"
                                                                object:self
                                                              userInfo:nil];
            break;
            
        case RowYear:
            self.yearSidePanelController.leftPanel = self.yearMenuTableViewController;
            self.yearSidePanelController.centerPanel = self.performanceYearVC;
            presentingViewController = self.yearSidePanelController;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yearMenuTapped"
                                                                object:self
                                                              userInfo:nil];
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

- (void)_presentInitialViewController
{
    id presentingViewController = nil;
    presentingViewController = self.artistsVC;
    
    CJMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSArray *newViewControllerStack = @[ [delegate.splitViewController.viewControllers firstObject], presentingViewController];
    delegate.splitViewController.viewControllers = newViewControllerStack;
    delegate.splitViewController.delegate = self;
    [self.tableView reloadData];
}

- (void)_initialize
{
    _selectedIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"sidebar"];
    self.tableView.backgroundView = imageView;
    CJMMenuHeaderView *headerView = [[CJMMenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[CJMMenuTableViewCell class] forCellReuseIdentifier:@"MenuCellIdentifier"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!_artistsVC) {
        _artistsVC = [[CJMArtistsViewController alloc] init];
    }
    
    if (!_songsVC) {
        _songsVC = [[CJMSongsViewController alloc] init];
    }
    
    if (!_genreVC) {
        _genreVC = [[CJMGenreViewController alloc] initWithMenuViewController:self];
    }
    
    if (!_performanceYearVC) {
        _performanceYearVC = [[CJMPerformanceYearViewController alloc] initWithMenuController:self];
    }
    
    if (!_genreSidePanelController) {
        _genreSidePanelController = [[JASidePanelController alloc] init];
        _genreSidePanelController.leftFixedWidth = 300.0f;
    }
    
    if (!_genreMenuTableViewController) {
        _genreMenuTableViewController = [[CJMGenreMenuTableViewController alloc] initWithMenuController:self];
    }
    
    if (!_yearSidePanelController) {
        _yearSidePanelController = [[JASidePanelController alloc] init];
        _yearSidePanelController.leftFixedWidth = 300.0f;
    }
    
    if (!_yearMenuTableViewController) {
        _yearMenuTableViewController = [[CJMYearMenuTableViewController alloc] initWithMenuController:self];
    }
    
    if (!_artistSidePanelController) {
        _artistSidePanelController = [[JASidePanelController alloc] init];
        _artistSidePanelController.leftFixedWidth = 300.0f;
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
