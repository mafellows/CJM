//
//  CJMArtistsViewController.m
//  CJM
//
//  Created by Michael Fellows on 7/30/14.
//  Copyright (c) 2014 CJM. All rights reserved.
//

#import "CJMArtistsViewController.h"

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
    return [self.sectionHeaders objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionHeaders count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CJMTableHeaderView *tableHeaderView = [[CJMTableHeaderView alloc] init];
    tableHeaderView.sectionTitleLabel.text = [self.sectionHeaders objectAtIndex:section];
    return tableHeaderView;
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
        cell = [[CJMTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    
    NSString *key = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *songs = [dictionary objectForKey:key];
    MPMediaItem *song = [songs objectAtIndex:indexPath.row];
    cell.songLabel.text = [NSString stringWithFormat:@"%@", [song valueForProperty:MPMediaItemPropertyTitle]];
    cell.trackLengthLabel.text = [self timeRemainingForDuration:[song valueForProperty:MPMediaItemPropertyPlaybackDuration]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *artist = [self.sectionHeaders objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.dictionaryArray objectAtIndex:indexPath.section];
    NSArray *songs = [dictionary objectForKey:artist];
    MPMediaItem *song = [songs objectAtIndex:indexPath.row];
    
    CJMAudioController *controller = [CJMAudioController sharedController];
    controller.currentItem = song;
    [controller playItem];
    
    [self.trackPlayingView.songTitleLabel setText:[song valueForProperty:MPMediaItemPropertyTitle]];
    [self.trackPlayingView.artistLabel setText:[song valueForProperty:MPMediaItemPropertyArtist]]; 
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
    NSLog(@"Unique Artists: %@", uniqueArtists);
    
    for (NSString *artist in uniqueArtists) {
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
    self.sectionHeaders = [uniqueArtists copy];
}


@end
