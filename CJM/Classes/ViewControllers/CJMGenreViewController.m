//
//  CJMGenreViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/30/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMGenreViewController.h"
#import "CJMMenuTableViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

@interface CJMGenreViewController ()

@property (nonatomic, copy) NSArray *dictionaryArray;
@property (nonatomic, copy) NSArray *sectionHeaders;
@property (nonatomic, strong) CJMMenuTableViewController *menuViewController;

@end

@implementation CJMGenreViewController

- (instancetype)initWithMenuViewController:(CJMMenuTableViewController *)menuViewController
{
    _menuViewController = menuViewController;
    if ((self = [super init])) {
        self.tableHeaderView.titleLabel.text = @"GENRE";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _fetchGenres];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.menuViewController.genreSidePanelController showLeftPanelAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(genreSelected:)
                                                 name:@"selectedGenre"
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"selectedGenre"
                                                  object:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CJMTableHeaderView *headerView = [[CJMTableHeaderView alloc] init];
    headerView.sectionTitleLabel.text = [self.sectionHeaders objectAtIndex:section];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionHeaders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:section];
    NSArray *genres = [dictionary objectForKey:[self.sectionHeaders objectAtIndex:section]];
    return genres.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJMTableViewCell *cell = (CJMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CJMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    NSString *key = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *genres = [dictionary objectForKey:key];
    MPMediaItem *song = [genres objectAtIndex:indexPath.row];
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
    NSString *genre = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *songs = [dictionary objectForKey:genre];
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

#pragma mark - Selector

- (void)genreSelected:(NSNotification *)aNotification
{
    if ([[aNotification name] isEqualToString:@"selectedGenre"]) {
        NSString *genre = [[aNotification object] objectForKey:@"genre"];
        self.tableHeaderView.titleLabel.text = [genre uppercaseString];
        [self _fetchSongsForGenre:genre];
    }
}

#pragma mark - Private

- (void)_fetchGenres
{
    NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
    MPMediaQuery *genresQuery = [MPMediaQuery genresQuery];
    NSArray *genres = [genresQuery items];
    
    NSMutableArray *allGenres = [NSMutableArray array];
    for (MPMediaItem *item in genres) {
        NSString *genre = [item valueForKey:MPMediaItemPropertyGenre];
        if (genre) [allGenres addObject:genre];
    }
    
    NSArray *uniqueGenres = [[NSSet setWithArray:allGenres] allObjects];
    NSLog(@"Unique Artists: %@", uniqueGenres);
    
    for (NSString *genre in uniqueGenres) {
        MPMediaPropertyPredicate *genrePredicate = [MPMediaPropertyPredicate predicateWithValue:genre
                                                                                    forProperty:MPMediaItemPropertyGenre
                                                                                 comparisonType:MPMediaPredicateComparisonEqualTo];
        
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        [songsQuery addFilterPredicate:genrePredicate];
        NSArray *songsArray = [songsQuery items];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:songsArray forKey:genre];
        [arrayOfDictionaries addObject:dictionary];
    }
    
    self.dictionaryArray = [arrayOfDictionaries copy];
    self.sectionHeaders = [uniqueGenres copy];
}

- (void)_fetchSongsForGenre:(NSString *)genre
{
    
    
    
}

@end
