//
//  CJMArtistsViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/30/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMArtistsViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "CJMAppDelegate.h"

@interface CJMArtistsViewController ()

@property (nonatomic, copy) NSArray *artists;
@property (nonatomic, copy) NSArray *dictionaryArray;
@property (nonatomic, copy) NSArray *sectionHeaders;

@end

@implementation CJMArtistsViewController

- (id)init
{
    if ((self = [super init])) {
        self.tableHeaderView.titleLabel.text = @"ARTISTS";
        self.tableHeaderView.caretButton.hidden = YES;
        [self.tableHeaderView updateConstraints];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _fetchArtists];
}

#pragma mark - Private

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return [self.sectionHeaders objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return [self.sectionHeaders count];
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        CJMTableHeaderView *tableHeaderView = [[CJMTableHeaderView alloc] init];
        tableHeaderView.sectionTitleLabel.text = [self.sectionHeaders objectAtIndex:section];
        return tableHeaderView;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:section];
        NSArray *songs = [dictionary objectForKey:[self.sectionHeaders objectAtIndex:section]];
        return songs.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        CJMTableViewCell *cell = (CJMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[CJMTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        }
        
        NSString *key = [self.sectionHeaders objectAtIndex:indexPath.section];
        NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
        NSArray *songs = [dictionary objectForKey:key];
        MPMediaItem *song = [songs objectAtIndex:indexPath.row];
        
        if (song == [[CJMAudioController sharedController] currentItem]) {
            cell.trackLengthLabel.hidden = YES;
            cell.speakerImageView.hidden = NO;
        } else {
            cell.trackLengthLabel.hidden = NO;
            cell.speakerImageView.hidden = YES;
        }
        cell.songLabel.text = [NSString stringWithFormat:@"%@", [song valueForProperty:MPMediaItemPropertyTitle]];
        cell.trackLengthLabel.text = [self timeRemainingForDuration:[song valueForProperty:MPMediaItemPropertyPlaybackDuration]];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *artist = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *songs = [dictionary objectForKey:artist];
    MPMediaItem *song = [songs objectAtIndex:indexPath.row];
    CJMAudioController *controller = [CJMAudioController sharedController];
    controller.currentItem = song;
    [controller setArrayOfSongs:songs withCurrentIndex:indexPath.row];
    [controller playItem];
    
    [self.trackPlayingView.songTitleLabel setText:[song valueForProperty:MPMediaItemPropertyTitle]];
    [self.trackPlayingView.artistLabel setText:[song valueForProperty:MPMediaItemPropertyArtist]]; \
    [self.tableView reloadData];
    
    [self.trackPlayingView.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
}

#pragma mark - Private

- (void)_fetchArtists
{
    NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
    MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
    NSArray *artists = [artistsQuery items];
    
    NSMutableArray *allArtists = [NSMutableArray array];
    for (MPMediaItem *item in artists) {
        NSString *song = [item valueForKey:MPMediaItemPropertyAlbumArtist];
        if (song) [allArtists addObject:song];
    }
    
    NSArray *uniqueArtists = [[NSSet setWithArray:allArtists] allObjects];
    NSMutableArray *sortedArtists = [NSMutableArray arrayWithArray:uniqueArtists];
    [sortedArtists sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortedArray = [sortedArtists copy];
    NSLog(@"%@", sortedArray);
    for (NSString *artist in sortedArray) {
        MPMediaPropertyPredicate *artistPredicate = [MPMediaPropertyPredicate predicateWithValue:artist
                                                                                     forProperty:MPMediaItemPropertyAlbumArtist
                                                                                  comparisonType:MPMediaPredicateComparisonEqualTo];
        
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        [songsQuery addFilterPredicate:artistPredicate];
        NSArray *songsArray = [songsQuery items];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:songsArray forKey:artist];
        [arrayOfDictionaries addObject:dictionary];
    }
    
    self.dictionaryArray = [arrayOfDictionaries copy];
    self.sectionHeaders = [sortedArtists copy];
}


@end
