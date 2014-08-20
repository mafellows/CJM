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

@interface CJMPerformanceYearViewController ()

@property (nonatomic, copy) NSArray *sectionHeaders;
@property (nonatomic, copy) NSArray *dictionaryArray;
@property (nonatomic, strong) CJMMenuTableViewController *menuController;

@end

@implementation CJMPerformanceYearViewController

- (instancetype)initWithMenuController:(CJMMenuTableViewController *)menuController
{
    if ((self = [super init])) {
        _menuController = menuController;
        self.tableHeaderView.titleLabel.text = @"PERFORMANCE YEARS";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    [self _fetchPerformancesForYear:firstYear];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.menuController.yearSidePanelController showLeftPanelAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yearSelected:)
                                                 name:@"selectedYear"
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                              forKeyPath:@"selectedYear"];
}

#pragma mark - Selector

- (void)yearSelected:(NSNotification *)aNotification
{
    if ([[aNotification name] isEqualToString:@"selectedYear"]) {
        NSNumber *year = [[aNotification object] objectForKey:@"year"];
        self.tableHeaderView.titleLabel.text = [[NSString stringWithFormat:@"%@", year] uppercaseString];
        [self _fetchPerformancesForYear:year];
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
    
    [self.trackPlayingView.songTitleLabel setText:[song valueForProperty:MPMediaItemPropertyTitle]];
    [self.trackPlayingView.artistLabel setText:[song valueForProperty:MPMediaItemPropertyArtist]];
    [self.tableView reloadData];
    
    [self.trackPlayingView.playButton setImage:[UIImage imageNamed:@"pause"]
                                      forState:UIControlStateNormal];
}

#pragma mark - Private

- (void)_fetchPerformancesForYear:(NSNumber *)year
{
    NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    
    NSMutableArray *songsForYear = [NSMutableArray array];
    for (MPMediaItem *song in songs) {
        if ([[song valueForProperty:@"year"] isEqualToNumber:year]) {
            [songsForYear addObject:song];
        }
    }
    
    NSLog(@"Songs for year: %@", songsForYear);
}

@end
