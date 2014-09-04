//
//  CJMPerformanceYearViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/30/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMPerformanceYearViewController.h"
#import "CJMMenuTableViewController.h"
#import "JASidePanelController.h"

static NSString * const YearStorageKey = @"yearKey";

@interface CJMPerformanceYearViewController ()

@property (nonatomic, copy) NSArray *sectionHeaders;
@property (nonatomic, copy) NSArray *dictionaryArray;
@property (nonatomic, strong) CJMMenuTableViewController *menuController;
@property (nonatomic, assign) BOOL sidePanelIsOpen;

@end

@implementation CJMPerformanceYearViewController

- (instancetype)initWithMenuController:(CJMMenuTableViewController *)menuController
{
    if ((self = [super init])) {
        _menuController = menuController;
        _sidePanelIsOpen = NO;
        [self.tableHeaderView.caretButton addTarget:self
                                             action:@selector(showMenu:)
                                   forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMenu:)
                                                 name:@"yearMenuTapped"
                                               object:nil];
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    
    NSMutableArray *allYears = [NSMutableArray array];
    for (MPMediaItem *item in songs) {
        NSNumber *year = [item valueForKey:@"year"];
        if (year) [allYears addObject:year];
    }
    
    NSArray *uniqueYears = [[NSSet setWithArray:allYears] allObjects];
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedUniqueYears = [uniqueYears sortedArrayUsingDescriptors:@[lowestToHighest]];
    NSNumber *firstYear = [sortedUniqueYears firstObject];
    
    NSNumber *selectedYear = [[NSUserDefaults standardUserDefaults] objectForKey:YearStorageKey];
    if (!selectedYear) {
        selectedYear = firstYear;
    }
    
    self.tableHeaderView.titleLabel.text = [NSString stringWithFormat:@"%@", selectedYear];
    [self _fetchPerformancesForYear:selectedYear];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.sidePanelIsOpen) {
        [self performSelector:@selector(showMenu:) withObject:self];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yearSelected:)
                                                 name:@"selectedYear"
                                               object:nil];
    
    UITapGestureRecognizer *tapRecogznier = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(showMenu:)];
    [self.tableHeaderView.titleLabel addGestureRecognizer:tapRecogznier];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.sidePanelIsOpen) {
        [self.menuController.yearSidePanelController toggleLeftPanel:self];
        self.sidePanelIsOpen = NO;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"selectedYear"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"yearMenuTapped"
                                                  object:nil];
}

#pragma mark - Selector

- (void)showMenu:(id)sender
{
    if (self.sidePanelIsOpen) {
        self.sidePanelIsOpen = NO;
    } else {
        self.sidePanelIsOpen = YES;
    }
    [self.menuController.yearSidePanelController toggleLeftPanel:self];
}

- (void)yearSelected:(NSNotification *)aNotification
{
    if ([[aNotification name] isEqualToString:@"selectedYear"]) {
        NSNumber *year = [[aNotification object] objectForKey:@"year"];
        [[NSUserDefaults standardUserDefaults] setObject:year forKey:YearStorageKey];
        self.tableHeaderView.titleLabel.text = [[NSString stringWithFormat:@"%@", year] uppercaseString];
        [self _fetchPerformancesForYear:year];
        self.sidePanelIsOpen = NO; // Side panel will always close after reloading data...
    }
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CJMTableHeaderView *headerView = [[CJMTableHeaderView alloc] init];
    NSNumber *year = [self.sectionHeaders objectAtIndex:section];
    headerView.sectionTitleLabel.text = [NSString stringWithFormat:@"%@", year];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionHeaders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:section];
    NSArray *songs = [dictionary objectForKey:[self.sectionHeaders objectAtIndex:section]];
    return songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJMTableViewCell *cell = (CJMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CJMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    NSString *key = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *songs = [dictionary objectForKey:key];
    MPMediaItem *song = [songs objectAtIndex:indexPath.row];
    NSNumber *duration = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
    int songDuration = [duration intValue];
    int minutes = songDuration / 60;
    int seconds = songDuration % 60;
    cell.songLabel.text = [NSString stringWithFormat:@"%@", [song valueForProperty:MPMediaItemPropertyTitle]];
    cell.trackLengthLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    
    if (song == [[CJMAudioController sharedController] currentItem]) {
        cell.trackLengthLabel.hidden = YES;
        cell.speakerImageView.hidden = NO;
    } else {
        cell.trackLengthLabel.hidden = NO;
        cell.speakerImageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *performanceYear = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *songs = [dictionary objectForKey:performanceYear];
    MPMediaItem *song = [songs objectAtIndex:indexPath.row];
    CJMAudioController *controller = [CJMAudioController sharedController];
    controller.currentItem = song;
    [controller setArrayOfSongs:songs withCurrentIndex:indexPath.row];
    [controller playItem];
    
    [self populateTrackView]; 
    [self.tableView reloadData];
    
    [self.trackPlayingView.playButton setImage:[UIImage imageNamed:@"pause"]
                                      forState:UIControlStateNormal];
    
    self.sidePanelIsOpen = NO; 
}

#pragma mark - Private

- (void)_fetchPerformancesForYear:(NSNumber *)year
{
    NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
    NSMutableArray *artistsForYear = [NSMutableArray array];
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    
    NSMutableArray *songsForYear = [NSMutableArray array];
    for (MPMediaItem *song in songs) {
        if ([[song valueForProperty:@"year"] isEqualToNumber:year]) {
            [songsForYear addObject:song];
            NSString *artist = [song valueForProperty:MPMediaItemPropertyAlbumArtist];
            if (![artistsForYear containsObject:artist] && artist != nil) {
                [artistsForYear addObject:artist];
            }
        }
    }
    
    [artistsForYear sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; 
    for (NSString *artist in artistsForYear) {
        MPMediaQuery *thisSongsQuery = [MPMediaQuery songsQuery];
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:artist
                                                                               forProperty:MPMediaItemPropertyAlbumArtist
                                                                            comparisonType:MPMediaPredicateComparisonEqualTo];
        [thisSongsQuery addFilterPredicate:predicate];
        NSArray *results = [thisSongsQuery items];
        NSMutableArray *mutableResults = [NSMutableArray array];
        for (MPMediaItem *song in results) {
            if ([[song valueForProperty:@"year"] isEqualToNumber:year]) {
                [mutableResults addObject:song];
            }
        }
        NSDictionary *dictionary = @{ artist : [mutableResults copy] };
        [arrayOfDictionaries addObject:dictionary];
    }
    
    self.sectionHeaders = [artistsForYear copy];
    self.dictionaryArray = [arrayOfDictionaries copy];
    [self.tableView reloadData];
}

@end
